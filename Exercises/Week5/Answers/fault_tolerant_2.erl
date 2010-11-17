-module(fault_tolerant_2).
-export([start/2,stop/1,rpc/2]).

start(Name,Mod) -> Pid = spawn (fun() -> 
					process_flag (trap_exit, true),
					restart(Name,Mod,Mod:init()) 
				end),
		   register(Name,Pid).

% helper function to be able to kill things easily.
stop(Name) -> exit (whereis (Name), die).

% restart the backup server and continue with normal operations
restart(Name,Mod,State) ->
    BackupPid = spawn_link(fun() ->
			      process_flag (trap_exit, true),
			      backup_server(Name,Mod,State)
		      end),
    server(Name,Mod,BackupPid,State)
	.

% main server operations
server(Name,Mod,BackupPid,State) ->
    io:format("Main ~w server ready, in state ~w. Backup is ~w.~n",
	      [self(), State, BackupPid]),
    receive
	{'EXIT', _KillerPid, die} -> 
            % stop the reflexive monitoring, kill the backup and finish.
	    unlink (BackupPid),
	    exit (BackupPid, kill);
	{'EXIT', KillerPid, Reason} -> 
	    io:format("~w exited by ~w because ~w~n", [self(), KillerPid, Reason]),
	    restart(Name, Mod, State);
	{Pid,Msg} ->
	    BackupPid ! {Pid,Msg}, % forward the request to the backup server
	    case catch Mod:handle(Msg,State) of
		{'EXIT',Reason} ->
		    reply(Name,Pid,{crash,Reason}),
		    server(Name,Mod,BackupPid,State);
		{Reply,NewState} ->
		    reply(Name,Pid,{ok,Reply}),
		    server(Name,Mod,BackupPid,NewState)
	    end
    end.

% backup server operations
backup_server (Name,Mod,State) ->
    io:format("Backup ~w server ready, in state ~w.~n", [self(), State]),
    receive
	{'EXIT', KillerPid, Reason} -> 
	    io:format("~w exited by ~w because ~w~n", [self(), KillerPid, Reason]),
	    register(Name,self()),
	    % main died, we become the new main.
	    restart(Name, Mod, State);
	{_Pid,Msg} ->
	    case catch Mod:handle(Msg,State) of
		{'EXIT',_Reason} ->
		    backup_server(Name,Mod,State);
		{_Reply,NewState} ->
		    backup_server(Name,Mod,NewState)
	    end
    end.


rpc(Name,Msg) ->
    io:format("~w querying ~w with ~w.~n", [self(), whereis(Name), Msg]),
    whereis (Name) ! {self(), Msg},
    receive 
	{Name,{crash,Reason}} -> exit(Reason);
	{Name,{ok,Reply}} -> Reply
    end.

reply(Name,Pid,Reply) ->
    io:format("~w replying to ~w with ~w.~n", [self(), Pid, Reply]),
    Pid ! {Name,Reply}.

