{-# LANGUAGE TypeOperators #-}
module AlgebraicTypes where


-- Example of parametric type
type NewNameForList a = [a]

-- Product
-- data a * b =
-- data One =

-- ex.
-- Circle
-- Rectangle

-- Sum
-- data a + b =
-- data Zero

-- ex.
-- Animal = Cat + Dog
-- Shape = Circle + Rectangle
-- Bool = 1+1

-- Bool is predefined in the Haskell prelude, with more intuitive tags

type a ≅ b = (a -> b, b -> a)
-- and the functions are inverses
-- (also known as bijection)
-- Algebra example: (a + b)×c  ≅  a×c + b×c
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

-- Three possible models for types, three different answers:

-- 1. substitution model: Just expand the List equation

-- 2. (For the brave) use the algebraic/combinatorial model. ie. solve the equation and do Taylor series expansion.)

-- 3. operational (von Neumann): Need an indirection

-- In Haskell, recursive types must be introduced with 'data'. (No good reason)

-- In fact, there is special syntax for list based on colon, brackets and commas.

-- Example: sum, product of [Int]


-- Example 2. Bin a = 1 + (Bin a * a * Bin a)

