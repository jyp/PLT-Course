{-# LANGUAGE BangPatterns #-}
module FibStream where

data Stream a = Cons !a (Thunk (Stream a))

type Thunk s = () -> s

thunk :: a -> Thunk a
thunk u () = u

force :: Thunk s -> s
force t = t ()

zipStream :: (a -> b -> c) -> Stream a -> Stream b -> Stream c
zipStream f (Cons x t) (Cons y s) = Cons (f x y) (thunk (zipStream f (force t) (force s)))

fibs :: Stream Integer
fibs = Cons 0 (thunk (Cons 1 (thunk (zipStream (+) fibs (tailStream fibs)))))

tailStream :: Stream a -> Stream a
tailStream (Cons x t) = force t

instance Show a => Show (Stream a) where
    show (Cons x _) = show x ++ "::" ++ "THUNK"

forceStream :: Stream a -> Int -> [a]
forceStream _          0 = []
forceStream (Cons x t) n = x : forceStream (force t) (n - 1)
