module ContinueState where

type StateEffect s = s -> s

type Cont eff a = (a -> eff) -> eff

type State s a = Cont (StateEffect s) a


-- get :: s (if we were to have side effects.)
-- get :: (s -> StateEffect s) -> StateEffect s -- capturing the effect in cont.
-- get :: (s -> s -> s) -> s -> s
get :: State s s
get k currentState = k currentState currentState

-- put :: s -> ()
-- put :: s -> (() -> StateEffect s) -> StateEffect s
put :: s -> (() -> s -> s) -> s -> s
put newState k currentState = k () newState

---------------
--  v = v+v;

prg :: State Int ()
prg k = get $ \v ->
        put (v+v) $ \() ->
        k ()

-- run :: State s a -> s -> s
run :: ((a -> s -> s) -> s -> s) -> s -> s
run f init0 = f (\_ init' -> init') init0


test = run prg


main = do
  print "Hello"
  getLine >>= \x ->
    print $ "You typed " ++ x

  
