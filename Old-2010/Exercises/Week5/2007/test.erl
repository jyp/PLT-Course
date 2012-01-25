-module(test).
-export([test/0, run2/0, run3/0]).

test() ->
    c:c(test), c:c(trans), c:c(stupid), test:run().

run2() ->
    catch server1x:stop(server),

    server1x:start(server,stupid),
    server1x:rpc(server,increment),
    server1x:rpc(server,increment),
    exit(whereis (server), kill),
    timer:sleep(100),
    server1x:rpc(server,look).
    

run3() ->
    catch exit(whereis (server), kill),
    trans:start(server,stupid),
    trans:start_transaction(server),
    trans:rpc(server,increment),
    trans:rpc(server,increment),
    spawn(fun() -> 
		  trans:rpc(server,increment)
	  end),
    %trans:rpc(server,look),
    trans:end_transaction(server),
    true.
    
