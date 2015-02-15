module Fold where

import Prelude hiding (sum,product,map,filter,foldl,foldr)


sum [] = 0
sum (x:xs) = x + sum xs

product [] = 1
product (x:xs) = x * product xs

passed [] = []
passed (x:xs) = if x >= 24 then x:passed xs else passed xs






