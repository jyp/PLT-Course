-module(trans).
-export([start/2,rpc/2,start_transaction/1,end_transaction/1,replay/3]).

start(Name,Mod) ->
    spawn(fun() ->
		  register(Name,self()),
		  server(Name,Mod,Mod:init(),[])
	  end).

% replay a list of queries, constructing the corresponding list of replies and final state.
replay(_Mod,State,[]) ->
    {State,[]};
replay(Mod,State, [Q|Qs]) ->    
    {State2,Rs} = replay (Mod,State,Qs),
    {R,FinalState} = Mod:handle(Q,State2),
    {FinalState, [R|Rs]}.
    
% type Pending = [{ClientPid,StateForThatClient,[{Query,Reply}]}]

server(Name,Mod,State,Pending) ->
    io:format ("Server state is now: ~w Pending: ~w~n",[State,Pending]),
    receive
	{Pid,AnyMessage} ->
	    io:format("Server got message ~w~n", [{Pid,AnyMessage}]),
	    case {Pid,AnyMessage} of
		{Pid,start_trans} ->
		    reply(Name,Pid,{ok,true}), 
		    % also possible: refuse if already in a transaction
		    server(Name,Mod,State,[{Pid,State,[]} | Pending]);
		{Pid,end_trans} ->
		    case lists:keysearch(Pid,1,Pending) of
			false -> 
			    reply(Name,Pid,{crash,no_transaction});
			{value, {Pid, _TransactionState, QRs}} ->
			    {Queries, Replies} = lists:unzip(QRs),
			    io:format ("Trying to commit... ~w, ~w, ~w~n", 
				       [Queries, Replies, replay(Mod,State,Queries)]),
			    case catch replay(Mod,State,Queries) of
				{NewState,Replies} -> % note that Replies is already bound 
				    reply(Name,Pid,{ok,true}),
				    server(Name,Mod,NewState,lists:keydelete(Pid,1,Pending));
				_ -> 
				    reply(Name,Pid,{ok,false}),
				    server(Name,Mod,State,lists:keydelete(Pid,1,Pending))
			    end
		    end;
		{Pid,Msg} ->
		    case lists:keysearch(Pid,1,Pending) of
			{value, {Pid, TransactionState, QRs}} ->
			    % client is in transaction mode
			    case catch Mod:handle(Msg,TransactionState) of
				{'EXIT',Reason} ->
				    reply(Name,Pid,{crash,Reason}),
				    server(Name,Mod,State,Pending);
				{Reply,NewState} ->
				    reply(Name,Pid,{ok,Reply}),
				    server(Name,Mod,State,
					   lists:keyreplace(Pid,1,Pending,
							    {Pid,NewState,[{Msg,Reply}|QRs]}))
			    end;
			false ->
			    % client is in "normal" mode
			    case catch Mod:handle(Msg,State) of
				{'EXIT',Reason} ->
				    reply(Name,Pid,{crash,Reason}),
				    server(Name,Mod,State,Pending);
				{Reply,NewState} ->
				    reply(Name,Pid,{ok,Reply}),
				    server(Name,Mod,NewState,Pending)
			    end
		    end
	    end
    end.

rpc(Name,Msg) ->
    io:format("RPC ready to send from ~w to ~w msg ~w~n", [self(),Name,Msg]),
    whereis (Name) ! {self(), Msg},
    receive 
	{Name,{crash,Reason}} -> exit(Reason);
	{Name,{ok,Reply}} -> Reply
    end.

start_transaction(Name) -> rpc (Name, start_trans).
end_transaction(Name) -> rpc (Name, end_trans).

reply(Name,Pid,Reply) ->
    io:format ("Server replies: ~w~n",[Reply]),
    Pid ! {Name,Reply}.

% -25 The state is split into individual variables 
% -30 The server does not reply immediately in a transaction 
% -25 The server does not replay queries 
% -15 The server does not test if replaying queries provides same replies 
% -5  Transaction fails if the state has changed
