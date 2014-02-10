{-# LANGUAGE GADTs, TypeOperators #-}

module ExplicitClosure where

import Prelude hiding (map)

-- 1. Chose a representation type for function (parameters)
data (==>) a b where
  Multiply :: Int -> Int ==> Int
  Add :: Int -> Int ==> Int

-- 2. Make a function which converts the representation back to an
-- actual function
apply :: (a ==> b) -> a -> b
apply (Multiply n) = \x -> x * n
apply (Add n) = \x -> x + n
-- 3. Perform the replacement of each occurence of
--     a. parameter type
--     b. call of a function parameter
--     c. function argument


map :: (a ==> b) -> [a] -> [b]
map _ [] = []
map f (x:xs) = apply f x : map f xs


multiply :: Int -> [Int] -> [Int]
multiply n = map (Multiply n)

add :: Int -> [Int] -> [Int]
add n = map (Add n)

