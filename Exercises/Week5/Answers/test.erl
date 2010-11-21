-module(test).
-export([client/0,server/0]).

server() ->
   transactional:start('name',client_api).

client() ->       
   spawn(fun() -> client_1() end),
   spawn(fun() -> client_2() end),
   spawn(fun() -> client_3() end),
   spawn(fun() -> client_4() end).
   
send(Msg)->
   transactional:rpc('name',Msg).
   
sendBlock(List) ->
   case List of
   [] -> done;
   [Msg|Rest] -> send(Msg), sendBlock(Rest)
   end.

doTransaction(List) ->
   transactional:start_transaction('name'),
 	 sendBlock(List),
   transactional:end_transaction('name').
   
client_1() ->
	doTransaction([verde, que, te, quiero, verde]).

client_2() ->
	doTransaction([solo, et, pensoso, i, piu, deserti, campi, vo, mesurando, a, passi, tardi, e, lenti]).

client_3() ->
	doTransaction([den, kloka, kvinnan, blir, glad, nar, hon, anses, vacker]).
	
client_4() ->
	doTransaction([den, vackra, kvinnan, blir, glad, nar, hon, anses, klok]).

   
