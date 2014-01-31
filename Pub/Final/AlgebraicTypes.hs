{-# LANGUAGE TypeOperators #-}


-- Example of parametric type
type NewNameForList a = [a]


-- Sum
data a + b = Inl a | Inr b
data Zero -- no constructors


-- Product
data a * b = Pair a b
type One = ()


-- Examples:

-- * Bool = 1+1

-- Note that, in the Haskell prelude, Bool is predefined with more
-- interesting tags

-- * Shape = Circle or Rectangle


-- Algebra example: (a + b)×c  =  a×c + b×c
-- Every algebraic equation induces an isomorphism.

-- Note that Haskell does not understand precedence at the level of type operators
f :: (a+b)*c -> (a*c) + (b*c)
f (Pair (Inl x) z) = Inl (Pair x z)
f (Pair (Inr x) z) = Inr (Pair x z)

g :: (a*c) + (b*c) -> (a+b)*c
g (Inl (Pair x z)) = (Pair (Inl x) z)
g (Inr (Pair x z)) = (Pair (Inr x) z)


-- Exponentials

--  Bool → A     ≅  A × A
--  (A+B) → C    ≅  (A → C) × (B → C)

-- (de)Currification:
--  (A × B) → C  ≅  A → B → C

-- Recursion

-- Example 1. List a = 1 + (a * List a)

-- What is a list? 

-- substitution model: Just expand the equation 
-- (For the brave: solve it and do Taylor series expansion.)
-- operational (von Neumann): Need an indirection

-- In Haskell, recursive types must be introduced with 'data'. (No good reason)

-- In fact, there is special syntax for list based on colon, brackets and commas.

-- Example: sum, product of [Int]


-- Example 2. Bin a = 1 + (Bin a * a * Bin a)

