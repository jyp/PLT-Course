
import Prelude hiding (foldr)

-- 67: foldr, (+), (*)

data Closure2 = Add2 | Mul2

applyCl2_2 :: Closure2 -> Integer -> Integer -> Integer
applyCl2_2 Add2 x y = x + y
applyCl2_2 Mul2 x y = x * y

foldr :: Closure2 -> Integer -> [Integer] -> Integer
foldr cl z []     = z
foldr cl z (x:xs) = applyCl2_2 cl z (foldr cl z xs)

test1 xs = foldr Add2 0 xs
test2 xs = foldr Mul2 0 xs


