{-# LANGUAGE RankNTypes #-}
module Fold where

import Prelude hiding (sum,product,map,filter)


-- fold :: Int -> (Int -> Int -> Int) -> [Int] -> Int
-- fold :: Char -> (Char -> Char -> Char) -> [Char] -> Char
fold :: forall a b. b -> (a -> b -> b) -> [a] -> b
fold base (#) [] = base
fold base (#) (x:xs) = x # fold base (#) xs

-- fold :: [Int] -> (Int -> [Int] -> [Int]) -> [Int] -> [Int]

passed :: [Int] -> [Int]
passed = fold [] (\x t -> if x >= 24 then x:t else t)

-- passed [] = []
-- passed (x:xs) = if x >= 24 then x:passed xs else passed xs

sum :: [Int] -> Int
sum = fold 0 (+)

product :: [Int] -> Int
product = fold 1 (*)






