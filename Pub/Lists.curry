
-- data [x] = [] | x : [x]

{-
-- Source:
append []     ys = ys
append (x:xs) ys = x : append xs ys
-}

-- Target:
append :: [a] -> [a] -> [a] -> Success
append []     ys zs = ys =:= zs
append (x:xs) ys zs = append xs ys zs' &
                      zs =:= x:zs'
   where zs' free


{-
-- Source:
reverse :: List x -> List x
reverse [] = []
reverse (x:xs) = reverse xs ++ [x]


-- Steps to translate the 2nd equation of the function reverse to relational style
-- (1st left as an exercise)

-- Start:

reverse (x:xs) = reverse xs ++ [x]

-- Change the left-hand-side to a relation (add an argument zs; the rhs becomes "zs =:= old result")

rev (x:xs) ys zs = zs =:= reverse ys ++ [x]

-- We cannot use ++ (it's a function); so we use the equivalent relation instead.  

rev (x:xs) ys zs = append (reverse ys) [x] zs

-- We cannot use reverse (it's a function); but we're not ready to convert it to a relation,
-- because it does not appear in the form "variable =:= reverse argument".
-- So we introduce a variable for that purpose:

rev (x:xs) ys zs = append ws [x] zs
                 & ws =:= reverse ys
   where ws free 

-- We can now replace reverse by the corresponding relation:

rev (x:xs) ys zs = append ws [x] zs
                 & rev ws ys
   where ws free 

-- and we're done: we use only relations or data constructors.

-}


-- Example queries:

-- suffix follows a given prefix?
-- append [1,2,3] ys [1,2,3,4,5] where ys free 

-- prefix precedes a given prefix?
-- append xs [4,5] [1,2,3,4,5] where xs free 


-- splitting a list
-- append xs ys [1,2,3,4,5] where xs ys free
