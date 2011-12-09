{-# LANGUAGE GADTs #-}

import Prelude hiding (map)

type List a = [a]


data Closure a b where
    Multiply :: Int -> Closure Int Int
    
apply :: Closure a b -> a -> b
apply (Multiply n) x = n * x


map :: Closure a b -> List a -> List b
map f [] = []
map f (x:xs) = apply f x : map f xs


multiply n = map (Multiply n)

