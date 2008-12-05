-module(server1).
-export([start/2,stop/1,rpc/2]).

% type State = {main/backup, backup's Pid, mod.state}


start(Name,Mod) -> Pid = spawn (fun() -> restart(Name,Mod,Mod:init()) end),
		   register(Name,Pid).

stop(Name) -> exit (whereis (Name), die).
		       

restart(Name,Mod,State) ->
    BackupPid = spawn_link(fun() ->
			      server(Name,Mod,backup,self(), State)
		      end),
    server(Name,Mod,main,BackupPid,State)
	.

% perhaps it's best to have to separate functions for the two roles.
server(Name,Mod,Kind,BackupPid,State) ->
    process_flag (trap_exit, true),
    SelfPid = self(),
    io:format("~w, ~w server ready in state ~w. Backup is ~w.~n",
	      [self(), Kind, State, BackupPid]),
    receive
	{'EXIT', _KillerPid, die} -> % makes sense only for the main process.
	    unlink (BackupPid),
	    exit (BackupPid, kill);
	{'EXIT', KillerPid, Reason} -> 
	    io:format("~w exited by ~w because ~w~n", [SelfPid, KillerPid, Reason]),
	    if
		Kind == backup ->
		    % main died, we become the new main.
		    register(Name, self ());
		true ->
		    true
	    end,
	    restart(Name, Mod, State);
	{Pid,Msg} ->
	    if Kind == main ->
		    BackupPid ! {Pid,Msg};
	       true -> true
	    end,
	    case catch Mod:handle(Msg,State) of
		{'EXIT',Reason} ->
		    maybeReply(Kind,Name,Pid,{crash,Reason}),
		    server(Name,Mod,Kind,BackupPid,State);
		{Reply,NewState} ->
		    maybeReply(Kind,Name,Pid,{ok,Reply}),
		    server(Name,Mod,Kind,BackupPid,NewState)
	    end
    end.

rpc(Name,Msg) ->
    whereis (Name) ! {self(), Msg},
    receive 
	{Name,{crash,Reason}} -> exit(Reason);
	{Name,{ok,Reply}} -> Reply
    end.

maybeReply(main,Name,Pid,Reply) ->
    reply (Name,Pid,Reply);
maybeReply(backup,Name,_Pid,Reply) -> {Name,Reply}.

reply(Name,Pid,Reply) ->
    Pid ! {Name,Reply}.

%  -15 The backup is registered under same name
%   -5 The backup is registered under "contant" name
%  -10 The backup server does not processes the requests
%   -5 The backup server does not "become" main, but "spawns" main again.
%   -5 The backup server sends replies too
%   -10 Only one process traps exits
%  -5 Processes are restarted with initial state


