{-# LANGUAGE GADTs, TypeOperators #-}

module ExplicitClosure where

import Prelude hiding (map)

-- 1. Chose a representation type for function parameters
-- data (==>) a b where

-- 2. Make a function which converts the representation back to an
-- actual function
-- apply :: (a ==> b) -> a -> b

-- 3. Perform the replacement of each occurence of
--     a. parameter type
--     b. call of a function parameter
--     c. function argument


map :: (a -> b) -> [a] -> [b]
map _ [] = []
map f (x:xs) = f x : map f xs


multiply :: Int -> [Int] -> [Int]
multiply n = map (\x -> x * n)

