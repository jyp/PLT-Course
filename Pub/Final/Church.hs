{-# LANGUAGE RankNTypes #-}
module Church where

-- variables.
-- abstraction: \x -> ..
-- application: f arg

-- Idea: represent a data-type by the type of its corresponding
-- primitive recursor (fold)

-- recall:
-- append [] ys = ys
-- append (x:xs) ys = x : append xs ys


newtype List a = Build {fold :: forall b. (a -> b -> b) -> b -> b}
newtype Nat    = BuildNat {foldNat :: forall b. (b -> b) -> b -> b}

nil :: List a
nil = Build $ \_c n -> n

cons :: a -> List a -> List a
cons x xs = Build $ \c n -> c x (fold xs c n)

sum' :: List Int -> Int
sum' xs = fold xs (+) 0


append :: List a -> List a -> List a
append xs ys = fold xs cons ys


