-module(test).
-export([reverse/1]).
reverse([]) -> [];
reverse([X | Xs]) -> reverse(Xs) ++ [X].

double(X) ->
    2 * X.
