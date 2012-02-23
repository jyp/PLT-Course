
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


-- Steps:
-- rev (x:xs) (reverse xs ++ [x]) = Success
-- rev (x:xs) ys = Success & ys =:= (reverse xs ++ [x])
-- rev (x:xs) ys = ys =:= (reverse xs ++ [x])
-- rev (x:xs) ys = ys =:= append (reverse xs) [x]
-- rev (x:xs) ys = ys =:= append zs [x] &  zs =:= reverse xs
-- rev (x:xs) ys = ys =:= append zs [x] & rev xs zs

-}


-- Example queries:

-- suffix follows a given prefix?
-- append [1,2,3] ys [1,2,3,4,5] where ys free 

-- prefix precedes a given prefix?
-- append xs [4,5] [1,2,3,4,5] where xs free 


-- splitting a list
-- append xs ys [1,2,3,4,5] where xs ys free
