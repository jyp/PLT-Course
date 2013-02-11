
import Prelude hiding (foldr)

-- Closures of @Integer -> Integer -> Integer@
data Closure = Add | Mul

applyCl :: Closure -> Integer -> Integer -> Integer
applyCl Add x y = x + y
applyCl Mul x y = x * y

foldr :: Closure -> Integer -> [Integer] -> Integer
foldr cl z []     = z
foldr cl z (x:xs) = applyCl cl x (foldr cl z xs)

test1 xs = foldr Add 0 xs   -- triangular numbers
test2 xs = foldr Mul 1 xs   -- factorials

