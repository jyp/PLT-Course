import Prelude((+), (*), print, Int, Num(..))
import Data.Char(chr)

data Closure = Plus | Multiply

foldr :: Num a => Closure -> a -> [a] -> a
foldr clos b (x:xs) = (apply clos) x (foldr clos b xs)
foldr _ b [] = b


apply :: Num a => Closure -> a -> a -> a
apply Plus = (+)
apply Multiply = (*)

test1, test2 :: [Int] -> Int
test1 xs = foldr Plus 0 xs
test2 xs = foldr Multiply 1 xs



data MapClosure = Charize

apply2 Charize 0 = 'z'
apply2 Charize c = chr c

map clos (x:xs) = apply2 clos x : map clos xs
map _    []     = []

test3 = map Charize

main = do
	print (test1 [1..10])
	print (test2 [1..10])
	print (test3 [0,97, 100, 110, 68, 0])
