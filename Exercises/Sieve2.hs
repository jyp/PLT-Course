import Prelude hiding (enumFrom, take, drop)

data List = -- Nil | (all lists are infinite here, so spare this constructor)
            Cons Int !Thunk
    deriving Show

-- Arguments to "Cons"
data Thunk = DelayEnumFrom Int 
           | DelaySieveFilter Int !Thunk
           | DelayFilter Int !Thunk
    deriving Show

n `divides` x = x `mod` n == 0

enumFrom :: Int -> List
enumFrom n = Cons n (DelayEnumFrom (n+1))

filterDiv :: Int -> List -> List
filterDiv n (Cons x xs) | n `divides` x = filterDiv n (force xs)
                        | otherwise = Cons x (DelayFilter n xs)

force (DelayEnumFrom n) = enumFrom n
force (DelaySieveFilter x xs) = sieve (filterDiv x (force xs))
force (DelayFilter x xs) = filterDiv x (force xs)

sieve :: List -> List
sieve (Cons x xs) = Cons x (DelaySieveFilter x xs)

primes = sieve (enumFrom 2)

-- for testing
take :: Int -> List -> [Int]
take 0 x = []
take n (Cons x xs) = x:take (n-1) (force xs)

-- cool to test this
drop :: Int -> List -> List
drop 0 x = x
drop n (Cons x xs) = drop (n-1) (force xs)

