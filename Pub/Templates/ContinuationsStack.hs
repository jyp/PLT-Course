module Continuations where

fact :: Int -> Int
fact 0 = 1
fact n = n * (fact (n-1))

test = fact 12

-- CPS transform

-- Closure conversion
-- (fix the effect to just returning an Int)

