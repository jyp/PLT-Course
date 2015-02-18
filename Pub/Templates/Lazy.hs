import Prelude hiding (filter, enumFrom)


data SList a = Nil | Cons a !(SList a)

crash = error "Error hit!"

-- type Thunk x = ...
-- delay :: x -> Thunk x
-- force :: Thunk x -> x



data LList a

-- xs is evaluated to a value; but it is a function, and so its body
-- is not evaluated (yet).

instance Show a => Show (SList a) where


enumFrom :: Int -> SList Int
enumFrom n = undefined

-- One more example:
filter :: (a -> Bool) -> SList a -> SList a
filter = undefined
