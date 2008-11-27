-module(logger).

-export([start/0, stop/0, log/1, test/0]).

start() ->
    Pid = spawn (fun() -> process_flag(trap_exit, true),
			  logging([])
		 end),
    % note that registering the process outside the spawn ensures that
    % the process is registered as the start function exits.
    register (logger_process, Pid).
						

stop() ->
    exit (whereis (logger_process), stopping),
    unregister (logger_process).

log(Event) ->
    link (whereis (logger_process)),
    logger_process ! {self(), Event}.
    
	
logging (Messages) ->
    receive
	{Pid, Event} ->	    
	    logging ([{Pid, Event} | Messages]); 
	    % all the messages are accumulated, instead we might want
	    % to keep only the last message per process. (using
	    % keyreplace)
	{'EXIT', Pid, _} -> 	    
	    {value,{Pid, Message}} = lists:keysearch (Pid, 1, Messages),
	    io:format ("Exited: ~w with ~w~n", [Pid, Message]),
	    logging (Messages)
    end.

		   
test() ->
    spawn(fun() ->
            logger:log(starting_1),
            Pid = spawn_link(fun() ->
                                 logger:log(starting_2),
                                 timer:sleep(1000),
                                 logger:log(stopping_2),
                                 1/0
                       end),
            logger:log(started_2),
            timer:sleep(100),
            logger:log(about_to_kill_2),
            exit(Pid,reason),
            timer:sleep(100),
            logger:log(stopping_1),
            exit(done)
          end).

