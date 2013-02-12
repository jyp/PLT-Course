import Prelude hiding (enumFrom, take)

-- Sum the elements in a file, lazily

data List = -- Nil | (all lists are infinite here, so I spare this constructor)
            Cons Int !Thunk
--    deriving Show

type Thunk = () -> List

n `divides` x = x `mod` n == 0

enumFrom :: Int -> List
enumFrom n = Cons n (delay $ enumFrom (n+1))

filterDiv :: Int -> List -> List
filterDiv n (Cons x xs) | n `divides` x = filterDiv n (force xs)
                        | otherwise = Cons x (delay $ filterDiv n (force xs))

force :: Thunk -> List
force t = t ()

delay :: List -> Thunk
delay xs () = xs


cribble :: List -> List
cribble (Cons x xs) = Cons x (delay $ cribble (filterDiv x (force xs)))

primes = cribble $ enumFrom 2

-- For testing
take :: Int -> List -> ([Int],Thunk)
take 1 (Cons x xs) = ([x],xs)
take n (Cons x xs) = (x:xs', rest)
    where (xs',rest) = take (n-1) (force xs)
          
test = fst $ take 10 primes          