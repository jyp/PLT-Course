{-# LANGUAGE ScopedTypeVariables #-}

-- Our state is an Integer (visited in the Java code)
type IP a = Integer -> (Integer,a)

-- If you can produce an a with this Integer state, and from
-- an a you can  produce a b with an Integer state, you can
-- get the b directly by threading the state appropriately.
andThen :: IP a -> (a -> IP b) -> IP b
m `andThen` f =
    \ s ->               -- The initial state is s
        let (s',a) = m s -- Get the a and the next state from m.
        in f a s'        -- Now give f the new state and the a.
                         -- f will return a new state and the b.

-- Simply returns the a without looking at, or changing, the
-- state. The state is just passed forward for later.
simply :: a -> IP a
simply x = \ s -> (s,x)

-- Gets the current state that is getting threaded
-- through the computation.
current :: IP Integer
current = \ s -> (s,s)

-- Changes the state (for subsequent calls to current).
-- The () that is returned is simply a dummy value,
-- like void in C/Java. (we have to return something.)
change :: (Integer -> Integer) -> IP ()
change f = \ s -> (f s,())

data Tree a = Branch (Tree a) a (Tree a) | Empty deriving Show

preorder :: forall a . Tree a -> Tree Integer
preorder t =
    let (_,t') = go t 0   -- discard final visit count with _
    in t'
  where
    go :: Tree a -> IP (Tree Integer)
    go Empty                 = simply Empty
    go (Branch left _ right) =
        current `andThen` \ my_visit_number ->
        change (+1) `andThen` \ () ->
        go left `andThen` \ l ->
        go right `andThen` \ r ->
        simply (Branch l my_visit_number r)

