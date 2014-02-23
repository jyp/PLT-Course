{-
-- Source:
append0 :: [a] -> [a] -> [a]
append0 []     ys = ys
append0 (x:xs) ys = x : append0 xs ys
-}

-- How can we transform the above in a relation?
append :: [a] -> [a] -> [a] -> Success



-- Example queries:

-- suffix follows a given prefix?
-- append [1,2,3] ys [1,2,3,4,5] where ys free 

-- prefix precedes a given prefix?
-- append xs [4,5] [1,2,3,4,5] where xs free 


-- splitting a list
-- append xs ys [1,2,3,4,5] where xs ys free
