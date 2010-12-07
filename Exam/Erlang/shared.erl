-module(shared).
-export([variable/1, var/1, getvar/1, putvar/2,test/0]).

variable(X) ->
	spawn(fun() -> var(X) end).

var(X) ->
	receive
		{put,Y} ->
			io:format("Server will set: ~w~n",[Y]),
			var(Y);
		{get,Pid} ->
			io:format("Server queried by: ~w~n",[Pid]),
			Pid ! {X},
			var(X)
	end.
	

getvar(VarPid) ->
	VarPid ! {get,self()},
	receive
		{Y} -> 
			io:format("Client ~w gets: ~w~n",[self(),Y])
	end.

putvar(VarPid,X) ->
	VarPid ! {put,X},
	io:format("Client ~w puts: ~w~n",[self(),X]).
	
spawn1(ServerPid,X) ->
	spawn(fun() -> 
				getvar(ServerPid),
				timer:sleep(100),
				putvar(ServerPid,X),
				getvar(ServerPid)
			end
			).
			
test() ->
	ServerPid = variable(firstvalue),
	spawn1(ServerPid,42),
	spawn1(ServerPid,erlang_rules),
	spawn1(ServerPid,sven_does_not_like_prolog).
