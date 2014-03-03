{-# LANGUAGE RankNTypes #-}
module Church where


-- Idea: represent a data-type by the type of its corresponding
-- primitive recursor (fold)

-- recall:
append [] ys = ys
append (x:xs) ys = x : append xs ys

-- How to write that as a fold?


