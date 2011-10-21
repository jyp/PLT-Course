
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

