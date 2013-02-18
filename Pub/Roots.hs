-- Newton's method for finding the square root of 'n':
-- take a 1st guess 'x'.
-- a better guess can then be obtained by the following formula:
next n x = (x + n/x) / 2

-- Here is an infinite list of better and better guesses:
approximations n initialGuess = iterate (next n) initialGuess 

-- In an infinite list of guesses, 'within eps' finds an approximation
-- within a certain error eps
within eps (x:y:xs) = if abs (x-y) < eps then y else within eps (y:xs)

-- To find the square root, construct an infinite list of
-- approximations and bound the error.
sqRoot n = within 0.01 (iterate (next n) (n/2))