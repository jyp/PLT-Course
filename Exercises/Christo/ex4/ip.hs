type State = Int

newtype IP a = IP {runIP  :: State -> (State, a)}

--type IP a = State -> (State, a)

andThen :: IP a -> (a -> IP b) -> IP b
f `andThen` g = IP $ \s0 ->
	let	(s1,a) = runIP f s0
		(s2,b) = runIP (g a) s1
        in  (s2,b)


getWorld :: IP State
getWorld = IP $ \s -> (s,s)

writeWorld :: State -> IP ()
writeWorld s = IP $ \_ -> (s, ())


instance Monad IP where
  (>>=) = andThen
  return x = IP $ \s0 -> (s0, x)


data Tree = Tree Int Tree Tree | Null
	deriving Show

replacePreorder :: Tree -> Tree
replacePreorder tree = snd (runIP (go tree) 0) where
	go Null = return Null
	go (Tree _ left right) = do
		val <- getWorld
		writeWorld (val+1)
		left' <- go left
		right' <- go right
		return (Tree val left' right')

replacePure :: Tree -> Tree
replacePure tree = fst (go (tree, 0))
	where
	go (Null, n) = (Null, n)
	go (Tree _ left right, n) = let
		(left', n') = go (left, n+1)
		(right', n'') = go (right, n')
		 in (Tree n left' right', n'')


testTree = Tree 14 (Tree 32 Null (Tree 322 Null Null)) (Tree 32 Null Null)

main = do
	print $ replacePreorder testTree
	print $ replacePure testTree
