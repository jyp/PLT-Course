data SList a = Nil | Cons a !(SList a)
  deriving Show
hd (Cons x xs) = x

crash = error "I refuse."

theList = Cons "a" (Cons "b" crash)

test = hd theList


  
  