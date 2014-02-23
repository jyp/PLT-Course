
-- data [x] = [] | x : [x]

{-
-- Source:
append0 :: [a] -> [a] -> [a]
append0 []     ys = ys
append0 (x:xs) ys = x : append0 xs ys
-}

-- Target:
append :: [a] -> [a] -> [a] -> Success
append []     ys zs = ys =:= zs
append (x:xs) ys zs = (x : ws) =:= zs & append xs ys ws
  where ws free

{-

Task: transform the function reverse into rev, written in relational style.

-- Source:
reverse :: [a] -> [a]
reverse [] = []
reverse (x:xs) = reverse xs ++ [x]

-- Type of rev:
-- rev :: [a] -> [a] -> Success

-- Steps to translate the 2nd equation of the function reverse to relational style
-- (1st left as an exercise)

-- Start:

reverse (x:xs) = reverse xs ++ [x]

-- Change the left-hand-side to a relation (add an argument zs; the rhs becomes "zs =:= old result")

rev (x:xs) ys = ys =:= reverse xs ++ [x]

-- We cannot use ++ (it's a function); so we use the equivalent relation instead.  

rev (x:xs) ys = append (reverse xs) [x] ys

-- We cannot use reverse (it's a function); but we're not ready to convert it to a relation,
-- because it does not appear in the form "variable =:= reverse argument".
-- So we introduce a variable for that purpose:

rev (x:xs) ys = append ws [x] ys
                & ws =:= reverse ys
   where ws free 

-- We can now replace reverse by the corresponding relation:
-- and we're done: we use only relations or data constructors.
-}
rev [] [] = success
rev (x:xs) ys = append ws [x] ys
                & rev xs ws
   where ws free

-- Example queries:

-- suffix follows a given prefix?
-- append [1,2,3] ys [1,2,3,4,5] where ys free 

-- prefix precedes a given prefix?
-- append xs [4,5] [1,2,3,4,5] where xs free 


-- splitting a list
-- append xs ys [1,2,3,4,5] where xs ys free
