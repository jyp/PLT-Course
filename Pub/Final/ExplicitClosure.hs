{-# LANGUAGE GADTs #-}

import Prelude hiding (map)

data Closure a b where
    Multiply :: Int -> Closure Int Int

apply :: Closure a b -> a -> b
apply (Multiply n) x = n * x

map :: a -> b -> [a] -> [b]
map f [] = []
map f (x:xs) = f x : map f xs

multiply n = map (\x -> x * 2)

