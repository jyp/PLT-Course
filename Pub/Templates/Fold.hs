module Fold where

import Prelude hiding (sum,product,map,filter)


sum [] = 0
sum (x:xs) = x + sum xs

product [] = 1
product (x:xs) = x * product xs

passed [] = []
passed (x:xs) = if x >= 24 then x:passed xs else passed xs

fold k f [] = k
fold k f (x:xs) = f x (fold k f xs)

filter p = fold [] (\x xs -> if p x then x:xs else xs)





