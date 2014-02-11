module ContinueState where

import Prelude hiding (sum)

data Tree a = Leaf | Bin (Tree a) a (Tree a)
one x = Bin Leaf x Leaf
example = Bin (one 1) 2 (Bin (one 3) 4 (one 5))

(<>) :: () -> () -> ()
_ <> _ = ()

traverse :: (a -> ()) -> Tree a -> ()
traverse visit Leaf = ()
traverse visit (Bin l x r) =
  traverse visit l <> visit x <> traverse visit r

traverseC :: (a -> (() -> f) -> f) -> Tree a -> (() -> f) -> f
traverseC visit Leaf k = k () 
traverseC visit (Bin l x r) k =
  traverseC visit l $ \tl ->
  visit x $ \fx ->
  traverseC visit r $ \tr ->
  k (tl <> fx <> tr)

flatten t = traverseC (\x xs -> x:xs ()) t (\() -> [])


