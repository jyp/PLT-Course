-module (stupid).

-export ([init/0, handle/2]).


init() ->
    0.

handle(increment, State) -> {ack,  State + 1};
handle(look, State)      -> {State,  State};
handle(decrement, 0)     -> {nack, 0};
handle(decrement, State) -> {ack,  State - 1}.
    


