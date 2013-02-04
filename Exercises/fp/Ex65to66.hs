module Ex65to66 where

import Data.List(insert)

sort :: [Integer] -> [Integer]
sort []     = []
sort (x:xs) = insert x (sort xs)

sort' :: [Integer] -> [Integer]
sort' = foldr insert []

