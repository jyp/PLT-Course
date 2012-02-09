
import Prelude (Int, (+), (++), Show(..), mod, (==))

data List = Nil | Cons Int List

instance Show List where
  show Nil = ""
  show (Cons x xs) = show x ++ "," ++ show xs

enumerateAllIntegers n = Cons n (enumerateAllIntegers (n+1)) 

startSituation = enumerateAllIntegers 2

removeAllMultiplesOf :: Int -> List -> List
removeAllMultiplesOf y Nil = Nil
removeAllMultiplesOf y (Cons x xs) = if isAMultipleOf y x
       then removeAllMultiplesOf y xs
       else Cons x (removeAllMultiplesOf y xs)

isAMultipleOf y x = x `mod` y == 0

sieve Nil = Nil
sieve (Cons x xs) = Cons x (sieve (removeAllMultiplesOf x xs))

primes = sieve (enumerateAllIntegers 2)

