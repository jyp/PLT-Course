module ContinueAccum where

data Tree a = Leaf | Bin (Tree a) a (Tree a)
  deriving Show

one x = Bin Leaf x Leaf
example = Bin (one 1) 2 (Bin (one 3) 4 (one 5))


-- flatten Leaf = []
-- flatten (Bin l x r) = flatten l ++ x : flatten r

(<>) :: () -> () -> ()
_ <> _ = ()

traverse :: (a -> (() -> eff) -> eff) -> Tree a -> (() -> eff) -> eff
traverse _visit Leaf k = k ()
traverse visit (Bin l x r) k =
   traverse visit l $ \tl ->
   visit x $ \vx ->
   traverse visit r $ \tr ->
   k (tl <> vx <> tr)

-- eff = [a]

flatten tree = traverse (\x xs -> x : xs ()) tree (\() -> [])

