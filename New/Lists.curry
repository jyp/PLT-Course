

-- data List x = Nil | Cons x (List x)


-- xs ++ ys = zs
append :: List x -> List x -> List x -> Success
append []     ys zs = ys =:= zs
append (x:xs) ys zs = append xs ys zs' &
                      zs =:= x:zs'



-- suffix follows a given prefix?
-- append [1,2,3] ys [1,2,3,4,5] where ys free 


-- prefix precedes a given prefix?
-- append xs [4,5] [1,2,3,4,5] where xs free 


-- splitting a list


-- append xs ys [1,2,3,4,5] where xs ys free 

