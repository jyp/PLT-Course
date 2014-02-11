module ContinueAccum where

data Tree a = Leaf | Bin (Tree a) a (Tree a)
  deriving Show

one x = Bin Leaf x Leaf
example = Bin (one 1) 2 (Bin (one 3) 4 (one 5))

(<>) :: () -> () -> ()
_ <> _ = ()

traverse :: (a -> ()) -> Tree a -> ()
traverse visit Leaf = ()
traverse visit (Bin l x r) =
  traverse visit l <> visit x <> traverse visit r

-- Have both the visit and the traverse function be continuations.

-- flatten t = 


