dotacc acc []     []     = acc
dotacc acc (x:xs) (y:ys) = dotacc (acc + x*y) xs ys
dotacc acc _      _      = error $ "unequal lengths!"

dot = dotacc 0

-- with explicit recursion:

dot' xs ys = sum (zipWith (*) xs ys)

-- make an abstract version of it? what does this mean?
-- no, dot product isn't in Data.List afaik

