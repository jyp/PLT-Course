
type Thunk x = () -> x

delay :: x -> Thunk x
delay x = \_ -> x

force :: Thunk x -> x
force t = t ()

data LList a = Nil | Cons a !(Thunk (LList a))

hd (Cons x xs) = x

crash = error "I refuse, my Lord."

instance Show a => Show (LList a) where
    show Nil = "."
    show (Cons x xs) = show x ++ "," ++ show (force xs)

theList = Cons "a" $ delay $ Cons "b" $ delay $ crash

enumFromm :: Int -> LList Int
enumFromm n = Cons n (delay $ enumFromm (n+1))

-- force a whole prefix of the list.
takeSome :: Int -> LList a -> [a]
takeSome 0 _ = []
takeSome n (Cons x xs) = x:takeSome (n-1) (force xs)