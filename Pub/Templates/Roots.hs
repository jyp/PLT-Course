module Roots where

-- import Prelude hiding (iterate)

-- Newton's method for finding the square root of 'n':
-- take a 1st guess 'x'.
-- a better guess can then be obtained by the following formula:
next :: Double -> Double -> Double
next n x = (x + n/x) / 2

-- iterate :: (a -> a) -> a -> [a]

-- Construct an infinite list of better and better guesses:
-- approximations :: Double -> Double -> [Double]
 

-- In an infinite list of guesses, 'within eps' finds an approximation
-- within a certain error eps

-- within :: Double -> [Double] -> Double


-- To find the square root, construct an infinite list of
-- approximations and bound the error.
-- sqRoot :: Double -> Double
-- sqRoot n = ...
