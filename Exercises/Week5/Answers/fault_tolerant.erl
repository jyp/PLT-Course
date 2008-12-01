-module(fault_tolerant).
-export([start/2,rpc/2]).

% type State = {main/backup, backup's Pid, mod.state}

start(Name,Mod) -> spawn (fun() -> register(Name,self()),
				   restart(Name,Mod,Mod:init()) end).

restart(Name,Mod,State) ->
    BackupPid = spawn_link(fun() ->
			      server(Name,Mod,backup,self(), State)
		      end),
    server(Name,Mod,main,BackupPid,State)
    .

server(Name,Mod,Kind,BackupPid,State) ->
    process_flag (trap_exit, true),
    receive
	{'EXIT', KillerPid, Reason} -> 
	    io:format("~w exited by ~w because ~w~n", [self(), KillerPid, Reason]),
	    if
		Kind == backup ->
		    % main died, we become the new main.
		    register(Name, self ());
		true ->
		    true
	    end,
	    restart(Name, Mod, State);
	{Pid,Msg} ->
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
    Name ! {self(), Msg},
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
%  -10 The backup server does not processes the requests
%   -5 The backup server does not "become" main, but "spawns" main again.
%   -5 The backup server sends replies too
