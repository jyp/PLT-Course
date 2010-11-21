-module(transactional).
-export([start/2,rpc/2,start_transaction/1,end_transaction/1]).
%%
% The messages used in this server:
% {Pid,transaction,Msg}  
%   This format is used by the server to keep track of the history
%   of the transaction identified by (Pid).
% {Pid,transaction_running,placeholder}
%   This format is used to keep track of the state of the transaction. There is 
%   just one of such messages per transaction.


%Caveats:
% This server does not allow a process to start more than one transaction.
% How would you extend it?
% (hint: use make_ref, and let the client identify his transaction.
%  You have also to extend the messages in the mailbox with the 
% Ref field, as the previously proposed solution).
%
% If a client fails, messages can remain inside the mailbox, and 
% this is a problem if a new client comes with the same PID. How 
% to address this (hint: linking)
%
% If a transaction contains multiple copies of the same atoms (see test:client_1),
% in the current implementation the transaction fails but the state
% is modified. This is because it is assumed that a transaction
% will not contain dupes. How would you extend the server and the
% client_api in order to (mutually exclusive):
%
% 1) (easy) Make the transaction fail when a duplicate in the same
%    transaction is detected.
%
% 2) (less easy) Allow duplicates to occurr in the same transaction.
%
% The modification should of course be generic in the server, that
% is, there must not be reference to the concepts of duplicates
% that are on a different abstraction level.


%% Spawns a new server with Name using module Mod.
%%  
start(Name,Mod) ->
  spawn(
    fun() ->
      register(Name,self()),
  	  server(Name,Mod,Mod:init())
	  end
  ).
	  
%% Empties the mailbox of messages of type {Pid,transaction,_}
%% The elements in brackets are not important
%% The point here is to iteratively delete the trace of the previous exchanges from
%% the mailbox.

cleanup_transaction(Pid) ->
  receive
    {Pid,transaction,_} ->
      cleanup_transaction(Pid)
  after
     0 -> done
  end.

%% Applies the transaction relative to identifier (Pid), by receiving all the
% messages in the mailbox previously queued by the server himself.
%
% Calls himself recursively if the history has no problems.
% As handle describes the next state of the protocol, in case the
% transition is nonvalid, the transaction has to be aborted.
% handle signals such an event with an exception (the catch part)
% 

apply_transaction(Pid,Mod,State) ->
  receive
    {Pid,transaction,Msg} ->

      try Mod:handle(Msg,State) of
	      {Reply,NewState} ->
		      apply_transaction(Pid,Mod,NewState)
	    catch
	      exit:Reason ->
  	      {transaction_aborted,Reason};
    	  _:_->
	        {transaction_aborted,wrong_reply}
	    end

  after
    0 -> {transaction_complete, State}
  end.

server_start_transaction(Name,Mod,State,Pid) ->
  srvprint("starting transaction for ~w~n",[Pid]),
    receive
      {Pid,transaction_running,placeholder} -> % If such a transaction was already started.
        failClient(Name,Pid,"Transaction already started"),
        server(Name,Mod,State)
    after 0 ->
  	  self() ! {Pid,transaction_running,placeholder},
  	  reply(Name,Pid,{ok,transaction_started}),
	    srvprint("Initiated transaction by ~w with msg ~w~n",[Pid,transaction_running]),
	    server(Name,Mod,State)
	  end.
	
	
%% Action taken if Pid requests end of transaction.
% If there is any record in the local mailbox of the server that 
% matches {Pid,transaction_running,placeholder} 
% then it means that the client actually started a transaction and the apply_transaction unrolls the steps.
%
% Otherwise, the Pid is asking to close a transaction that was
% not started, resulting in a request to crash from the server.
server_end_transaction(Name,Mod,State,Pid) ->
	srvprint("Ending transaction for ~w ~n",[Pid]),
	receive
 	  {Pid,transaction_running,placeholder} ->
		srvprint("Existent transaction for ~w ~n",[Pid]),
		case apply_transaction(Pid,Mod,State) of
		  {transaction_complete,NewState} ->
  	      % The transaction was applied successfully.
			  srvprint("Transaction successful for ~w ~n",[Pid]),
		    reply(Name,Pid,{ok,transaction_ended}),
			  server(Name,Mod,NewState);

		  {transaction_aborted,wrong_reply} ->
		  % The transaction was aborted because, e.g., the protocol was not respected
			  srvprint("Protocol not respected by ~w ~n",[Pid]),
        failClient(Name,Pid,Reason),
        server(Name,Mod,State);
						
	    {transaction_aborted,Reason} ->
	      % The transaction was aborted for some other reason, there fore the client is asked to crash.
        failClient(Name,Pid,Reason),
        server(Name,Mod,State)
		end
	after 0 ->
	% The transaction requested to be ended was never initiated. Request to crash.
    srvprint("Non-existent Transaction for ~w ~n",[Pid]),
    failClient(Name,Pid,Reason),
    server(Name,Mod,State)
	end.

%%
% This method simply acknowledges the action if a transaction has
% been initiated. 
%
%
server_intermediate_message(Name,Mod,State,Pid,Msg) ->
  receive
    {Pid,transaction_running,placeholder} -> % Did the transaction ever start?
      srvprint("intermediate action, existent transaction for ~w,~w ~n",[Pid,Msg]),
		  reply(Name,Pid,{ok,''}),
      self() ! {Pid,transaction_running,placeholder}, % Insert again the placeholder in the mailbox
		  self() ! {Pid,transaction,Msg}, % Insert the message in the mailbox
	  	server(Name,Mod,State)			
    after 0 ->  %% No transaction running in the mailbox; the logic to deal with this is demanded to the Mod module
                % that should possibly throw an exception 
    	srvprint("Timeout for ~w,~w ~n",[Pid,Msg]),

      try Mod:handle({Msg},State) of % Stateless query.
		    {Reply,NewState} ->
	      reply(Name,Pid,{ok,Reply}),
		    server(Name,Mod,NewState)
	    catch 
	  	  exit:Reason -> % Request to crash.
        failClient(Name,Pid,Reason),
		    server(Name,Mod,State)
	    end
  end.


server(Name,Mod,State) ->
  receive
    {Pid,start_transaction} ->
  	  srvprint("start ~w~n",[Pid]),
		  server_start_transaction(Name,Mod,State,Pid);
      
    {Pid,end_transaction} ->
  	 	srvprint("end ~w ~n",[Pid]),
      server_end_transaction(Name,Mod,State,Pid);

	  {Pid,Msg} ->
	    srvprint("intermediate ~w,~w ~n",[Pid,Msg]),
      server_intermediate_message(Name,Mod,State,Pid,Msg)

  end.

failClient(Name,Pid,Reason) ->
  srvprint("Crashing ~w ~n",[Pid]),
  reply(Name,Pid,{crash,Reason}),
  cleanup_transaction(Pid).

start_transaction(Name) -> rpc(Name, start_transaction).

end_transaction(Name) -> rpc(Name, end_transaction).

rpc(Name,Msg) ->
	cliprint("before sending ~w ~n",self(),[Msg]),
    Name ! {self(), Msg},
   	cliprint("after sending ~w~n",self(),[Msg]),
    receive 
		  {Name,{crash,Reason}} -> cliprint("I am crashing because ~p ~n",self(),[Reason]),exit(Reason);
		  {Name,{ok,Reply}} -> Reply
    end.

reply(Name,Pid,Reply) ->
    Pid ! {Name,Reply}.

srvprint(Str,Vals)->
  io:format(string:concat("Server: ",Str),Vals).
  
cliprint(Str,Pid,Vals)->
  io:format(string:concat("Client ~w :",Str),[Pid|Vals]).

