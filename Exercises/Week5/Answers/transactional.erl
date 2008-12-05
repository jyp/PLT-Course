-module(transactional).
-export([start/2,rpc/2,start_transaction/1,end_transaction/1]).

start(Name,Mod) ->
    spawn(fun() ->
		  register(Name,self()),
		  server(Name,Mod,Mod:init(),make_ref())
	  end).

cleanup_transaction(Pid,Ref) ->
    receive
        {Pid,Ref,transaction,_,_} ->
	    cleanup_transaction(Pid,Ref)
    after
        0 -> done
    end.

apply_transaction(Pid,Ref,Mod,State) ->
    receive
        {Pid,Ref,transaction,Msg,Reply} ->
	    case catch Mod:handle(Msg,State) of
	        {Reply,NewState} ->
		    apply_transaction(Pid,Ref,Mod,NewState);
		{'EXIT',Reason} ->
		    cleanup_transaction(Pid,Ref),
		    {transaction_aborted,Reason};
		{_, _} ->
		    cleanup_transaction(Pid,Ref),
		    {transaction_aborted,wrong_reply}
	    end
    after
        0 -> {transaction_complete, State}
    end.

server(Name,Mod,State,Ref) ->
    receive
        {Pid,start_transaction} ->
	    self() ! {Pid,Ref,transaction_running,State},
	    reply(Name,Pid,{ok,transaction_started});
	{Pid,end_transaction} ->
	    receive
 	        {Pid,Ref,transaction_running,_} ->
		    case apply_transaction(Pid,Ref,Mod,State) of
		        {transaction_complete,NewState} ->
		            reply(Name,Pid,{ok,transaction_ended}),
			    server(Name,Mod,NewState,Ref);
			{transaction_aborted,wrong_reply} ->
			    reply(Name,Pid,{ok,{transaction_aborted,resend}});
			{transaction_aborted,Reason} ->
			    reply(Name,Pid,{crash,Reason})
		    end
	    after
	        0 ->
		    reply(Name,Pid,{crash,no_active_transaction})
	    end;
	{Pid,Msg} ->
  	    receive
	        {Pid,Ref,transaction_running,TempState} ->
		    case catch Mod:handle(Msg,TempState) of
		        {'EXIT',Reason} ->
		            reply(Name,Pid,{crash,Reason}),
			    cleanup_transaction(Pid,Ref); %CLIENT CRASHED
			{Reply,NewState} ->
			    reply(Name,Pid,{ok,Reply}),
			    self() ! {Pid,Ref,transaction_running,NewState},
			    self() ! {Pid,Ref,transaction,Msg,Reply}

		    end,
		    server(Name,Mod,State,Ref)
	    after
	        0 ->
		    case catch Mod:handle(Msg,State) of
		    	{'EXIT',Reason} ->
			    reply(Name,Pid,{crash,Reason}),
			    server(Name,Mod,State,Ref);
			{Reply,NewState} ->
			    reply(Name,Pid,{ok,Reply}),
			    server(Name,Mod,NewState,Ref)
	    end
    end


    end.

start_transaction(Name) -> rpc(Name, start_transaction).

end_transaction(Name) -> rpc(Name, end_transaction).

rpc(Name,Msg) ->
    Name ! {self(), Msg},
    receive 
	{Name,{crash,Reason}} -> exit(Reason);
	{Name,{ok,Reply}} -> Reply
    end.

reply(Name,Pid,Reply) ->
    Pid ! {Name,Reply}.

