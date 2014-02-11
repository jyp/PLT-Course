

type StateEffect s = ???

type Cont k a = (a -> k) -> k

type State s a = Cont (StateEffect s) a


get :: State s s
get = ?

put :: s -> State s ()
put s = ?

---------------
--  v = v+v;

prg :: State Int ()
prg k = get $ \v ->
        put (v+v) $ \() ->
        k ()

run :: State s a -> s -> s
run f init = ???


test = run prg
