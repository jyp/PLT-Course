type Church = forall a. (a -> a) -> (a -> a)

inc = \x -> x + 1

twice = \f x -> f (f x)

----

church n = \f x -> foldr (.) id (replicate n f) x

church0 = \f x -> x

church1 = \f x -> f x

unChurch n = n inc 0

suc n = \f x -> f (n f x) 

add n m = \f x -> n f (m f x)
-- add n m = \f -> n f . m f

mul n m = \f -> n (m f)
-- mul n m = \f x -> n (m f) x
-- mul = (.)

----

cons = \x y f -> f x y

car = \cell -> cell (\x y -> x) -- cell const

cdr = \cell -> cell (\x y -> y) -- cell (flip const)