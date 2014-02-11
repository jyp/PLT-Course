import Prelude hiding (filter)


data SList a = Nil | Cons a !(SList a)

crash = error "Error hit!"

-- type Thunk x = ...
-- delay :: x -> Thunk x
-- force :: Thunk x -> x



data LList a

-- xs is evaluated to a value; but it is a function, and so its body
-- is not evaluated (yet).

instance Show a => Show (LList a) where


enumFromm :: Int -> LList Int
enumFromm n = undefined

-- One more example:
filter :: (a -> Bool) -> LList a -> LList a
filter = undefined
