import Data.Array

ld s t = d!(m,n)
   where bounds = ((0,0),(m,n))
         m = length s
         n = length t
         d :: Array (Int,Int) Int
         d = array bounds [((i,j),val i j) | (i,j) <- range bounds]
         val i j | i == 0 = j
                 | j == 0 = i
                 | s!!(i-1) == t!!(j-1) = d!(i-1,j-1)
                 | otherwise = minimum [d!(i-1,j)+1, d!(i,j-1)+1, d!(i-1,j-1)+1]

 