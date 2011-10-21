data SList a = Nil | Cons a !(SList a)

hd (Cons x xs) = x

crash = error "I refuse, my Lord."

theList = Cons "a" (Cons "b" crash)

test = hd theList


---------------------------------------------------
