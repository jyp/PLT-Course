import Data.Array

levenshteinDistance :: Eq a => [a] -> [a] -> Int
levenshteinDistance s t = d!(m,n)
  where
    m = length s
    n = length t
    bounds = ((0,0),(m,n))
    d :: Array (Int,Int) Int
    d = array bounds [((i,j),val i j) | (i,j) <- range bounds]
    val 0 j = j
    val i 0 = i
    val i j | s!!(i-1) == t!!(j-1) = d!(i-1,j-1)
    val i j = minimum [d!(i-1,j)+1, d!(i,j-1)+1, d!(i-1,j-1)+1]
