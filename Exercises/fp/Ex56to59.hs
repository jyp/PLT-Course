module Ex56to59 where

import Prelude hiding (max)
import qualified Prelude as P

-- 56
f :: Int -> Int
f x | x > 0     = x
    | otherwise = 0

-- 57
max :: (Int,Int) -> Int
max = uncurry P.max

f' :: Int -> Int
f' x = max (x,0)

-- 58
max' :: Int -> Int -> Int
max' x y = max (x,y)

-- 59
f'' :: Int -> Int
f'' = max' 0

