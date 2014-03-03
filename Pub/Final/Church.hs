{-# LANGUAGE RankNTypes #-}
module Church where


-- Idea: represent a data-type by the type of its corresponding
-- primitive recursor (fold)

newtype List a = Build {fold :: forall b. (a -> b -> b) -> b -> b}


nil :: List a
nil = Build $ \_ n -> n

cons :: a -> List a -> List a
cons x xs = Build $ \c n -> c x (fold xs c n)


-- append [] ys = ys
-- append (x:xs) ys = x : append xs ys

-- append xs ys = foldr (:) ys xs


-- Note: append requires a 'newtype' declaration
append :: List a -> List a -> List a
append xs ys = fold xs cons ys

sum' :: List Int -> Int
sum' xs = fold xs (+) 0

