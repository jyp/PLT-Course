
type Thunk x = () -> x

delay :: x -> Thunk x
delay x = \_ -> x

-- NOTE: the function does not compute its body until the argument is
-- applied:

-- force :: (() -> x) -> x
force :: Thunk x -> x
force t = t ()


data LList a = Nil | Cons a !(Thunk (LList a))


-- xs is evaluated to a value; but it is a function, and so its body
-- is not evaluated (yet).
hd (Cons x xs) = x


crash = error "I refuse."

instance Show a => Show (LList a) where
    show Nil = "."
    show (Cons x xs) = show x ++ "," ++ show (force xs)

theList = Cons "a" (delay (Cons "b" (delay crash)))

enumFromm :: Int -> LList Int
enumFromm n = Cons n (delay $ enumFromm (n+1))

-- force a whole prefix of the list.
takeSome :: Int -> LList a -> [a]
takeSome 0 _ = []
takeSome n (Cons x xs) = x:takeSome (n-1) (force xs)

-- One more example:
filter :: (a -> Bool) -> LList a -> LList a
filter p Nil = Nil
filter p (Cons x xs) = if p x then Cons x xs
                              else force xs