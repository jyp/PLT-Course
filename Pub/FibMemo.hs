import Data.Array

n = 1000000

fibs = array (0,n) [(i,f i) | i <- [0..n]]
  where f 0 = 0
        f 1 = 1
        f i = fibs!(i-1) + fibs!(i-2)
