import Data.Array
import System.IO.Unsafe


type D2 = (Int, Int)

test :: [Bool]
test = map (==1) $ concat
	[ [1,1,0,0,0,0,0]
	, [1,1,1,0,0,0,0]
	, [0,1,1,0,0,0,0]
	, [0,0,0,1,1,1,0]
	, [0,0,0,1,1,1,0]
	, [0,0,0,1,1,1,1]
	, [0,0,0,0,0,1,1] ]

buildWarshall :: Int -> [Bool] -> Array (Int, Int) Bool
buildWarshall n = go 0 . listArray ((0,0), (n-1,n-1)) 
	where
	go k a	| k<n		=  go (k+1) $ listArray (bounds a) $
					[a!(i,j) || (a!(i,k) && a!(k,j)) | j <- [0..n-1], i <- [0..n-1]]
		| otherwise	= a


connected i j ws = ws!(i,j)

main = do
	let ws = buildWarshall 7 test
	print $ connected 0 6 ws
	print $ connected 0 2 ws
