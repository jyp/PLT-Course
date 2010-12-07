-module(foo).
-export([foo/0]).

foo()->
	Self = self(),
	spawn(fun()-> Self ! a end),
	spawn(fun()-> Self ! b end),
	receive A ->
		receive B ->
			{A,B}
		end
	end.

