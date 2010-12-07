-module(exam_locks).
-export([test/0]).

%% 
% claim and release are the client side functions. 
%  
% In both claim and release requests, the server has to reply 
% to a message 
%     {claim|release,Pid} 
%  immediately with an acknowledgement {ok};
%   the client fails if: 
%       this does not happen in a timeout, .
%       the received message is not {ok}
%  
% the functions unlocked() and locked(Pid) model the two state
% behavior of the server.
% Message by other clients (than Pid) in the locked(Pid) state 
% are ignored.
% Clients (see startXClient functions) are linked to the server 
% process (which is a system process, see start function)
% in such a way that if the server detects that the client holding
% the link has failed, he returns in the unlocked state.

% use test/0 to see a demonstration

claim()->
	whereis(server) ! {claim,self()},
	log_requested(),
	receive
		{ok} -> log_acquired();
		_ -> exit("Unexpected message")
	after 5000 ->
		io:format("~w : Giving up~n",[self()])
	end.
	
release() ->
	whereis(server) ! {release,self()},
	receive 
		{ok} -> log_released();
		_ -> exit("Unexpected message")
	after 1000 ->
		log_not_released()
	end.

start()->
	spawn(
		fun() ->
			register(server,self()),
			process_flag(trap_exit,true),
			unlocked()
		end
	).
	
unlocked() ->
	receive
		{claim,Pid} ->
			Pid ! {ok},
			log_server_acquired(Pid),
			locked(Pid);
		M -> 
			log_server_ignore(M),
			unlocked()
	end.
	
locked(Pid) ->
	receive
		{release,Pid} ->
			Pid ! {ok},
			log_server_released(Pid),
			unlocked();
			
		{'EXIT', Pid, Why} -> 
			log_server_released_crash(Pid),
			unlocked();
			
		M -> log_server_ignore(M),
			locked(Pid)
	end.

startGoodClient(X) ->
	spawn(fun() ->
			link(whereis(server)),
			claim(),
			timer:sleep(X),
			release()
		end
		).
		
startGoodClientThatFails(X) ->
	spawn(fun() ->
			link(whereis(server)),
			claim(),
			timer:sleep(X)
		end
		).
	
startBadClient(X) ->
	spawn(fun() ->
			link(whereis(server)),
			timer:sleep(X),
			release(),
			release()	
		end
		).	
test()->
	start(),
	timer:sleep(1000),
	startGoodClientThatFails(10),
	startGoodClient(10),
	timer:sleep(200),
	startGoodClient(100),
	startGoodClient(10),
	startBadClient(10),
	timer:sleep(1000),
	exit(whereis(server),kill),
	unregister(server).

log_server_ignore(Msg) ->
	io:format("Server : Ignoring message ~w ~n",[Msg]).

log_server_acquired(Pid) ->
	io:format("Server : Acquired by ~w~n",[Pid]).

log_server_released(Pid) ->
	io:format("Server : Released by ~w~n",[Pid]).
	
log_server_released_crash(Pid) ->
	io:format("Server : Released by ~w due to crash~n",[Pid]).

log_acquired() ->
	io:format("~w : Lock acquired~n",[self()]).

log_requested() ->
	io:format("~w : Lock requested~n",[self()]).
	
log_released() ->
	io:format("~w : Lock released~n",[self()]).
	
log_not_released() ->
	io:format("~w : Lock not released~n",[self()]).
