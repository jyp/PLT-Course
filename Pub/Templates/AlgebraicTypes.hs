{-# LANGUAGE TypeOperators #-}
module AlgebraicTypes where


-- Example of parametric type
type NewNameForList a = [a]


-- Product
data a * b =
type One =

-- Sum
data a + b =
data Zero



-- Examples:

-- * Bool = 1+1

-- Note that, in the Haskell prelude, Bool is predefined with more
-- interesting tags

-- * Shape = Circle or Rectangle


type Iso a b = (a -> b, b -> a) -- and function are inverses
-- Algebra example: (a + b)×c  =  a×c + b×c
-- Every algebraic equation induces an isomorphism.

-- Note that Haskell does not understand precedence at the level of type operators

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

