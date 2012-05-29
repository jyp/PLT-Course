
primes :: [Int]
primes = sieve [2..]

sieve :: [Int] -> [Int]
sieve (n:ns) = n : sieve (filter (\x -> x `rem` n /= 0) ns)

main = print (primesT!!!10000)


type Thunk x = () -> x
data SList a = Null | Cons !a !(Thunk (SList a))

filterS :: (a -> Bool) -> SList a -> SList a
filterS _ Null = Null
filterS p (Cons x xs) | p x       = Cons x (delay (filterS p (force xs)))
                      | otherwise = (filterS p (force xs))

sieveT :: SList Int -> SList Int
sieveT (Cons n ns) = Cons n (delay (sieveT (filterS (\x -> x `rem` n /= 0) (force ns))))

primesT = sieveT (enumFromm 2)

delay :: x -> Thunk x
delay x = \_ -> x

force :: Thunk x -> x
force t = t ()

enumFromm :: Int -> SList Int
enumFromm n = Cons n (delay $ enumFromm (n+1))

(Cons x _) !!! 0 = x
(Cons x xs) !!! n = force xs !!! (n-1)
