module Continuations where

{-

fact :: Int -> Int
fact 0 = 1
fact n = n * (fact (n-1))

test = fact 12

-}

-- CPS transform

{-

fact :: Int -> ((Int -> eff) -> eff)
fact 0 k = k 1
fact n k = fact (n-1) $ \fn ->
           k (fn * n)

test = fact 12 id

-}


-- Closure conversion
-- (we have fixed the effect to just returning an Int)

-- | Closure of 'type' Int -> Int
data Closure = Id
             | Mult Closure Int

apply :: Closure -> Int -> Int
apply Id x = x
apply (Mult k n) x = apply k (x * n)

fact :: Int -> Closure -> Int
fact 0 k = apply k 1
fact n k = fact (n-1) (Mult k n)

test = fact 12 Id


