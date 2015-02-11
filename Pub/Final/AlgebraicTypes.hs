{-# LANGUAGE TypeOperators #-}
module AlgebraicTypes where

import Control.Applicative
import Prelude hiding (sum, reverse)

-- Example of parametric type
type MyList a = [a]

-- Product
data a * b = Pair a b
  deriving (Eq,Show)
-- type a * b = (a,b)
data One = Unit
  deriving (Eq,Show)

-- ex.
type Point = Float * Float
type Circle = Point * Float
-- data Circle = Circle { center :: Point, radius :: Float }

type Rectangle = Point * Point

-- Sum
data a + b = Inl a | Inr b
  deriving (Eq,Show)
data Zero
  deriving (Eq,Show)

-- ex.
-- type Animal = Cat + Dog
type Shape = Circle + Rectangle
-- type Bool = One + One
-- data Bool = False | True

true = Inl Unit
false = Inr Unit

-- Bool is predefined in the Haskell prelude, with more intuitive tags

type a ≅ b = (a -> b, b -> a)
-- type a ≅ b = (a -> b) * (b -> a)
-- and the functions are inverses
-- (also known as bijection)
-- Algebra example: (a + b)×c  ≅  a×c + b×c
-- Every algebraic equation induces an isomorphism.

f :: (a + b)*c  ->  (a*c) + (b*c)
f (Pair (Inl x) z) = Inl (Pair x z)
f (Pair (Inr y) z) = Inr (Pair y z)

g :: (a*c) + (b*c) -> (a + b)*c
g (Inl (Pair x z)) = (Pair (Inl x) z)
g (Inr (Pair y z)) = (Pair (Inr y) z)
  
test1 :: ((a + b)*c)  ≅  ((a*c) + (b*c))
test1 = (f,g)

prop_fg :: ((Int * Int) + (Int * Int)) -> Bool
prop_fg x = f (g x) == x

prop_gf :: (Int + Int) * Int -> Bool
prop_gf x = g (f x) == x

instance Eq Zero where
  x == y = error "magic"

instance (Arbitrary a, Arbitrary b) => Arbitrary (a * b) where
  arbitrary = Pair <$> arbitrary <*> arbitrary
instance Arbitrary One where arbitrary = return Unit
instance (Arbitrary a, Arbitrary b) => Arbitrary (a + b) where
  arbitrary = do
    oneof [Inl <$> arbitrary,Inr <$> arbitrary]


{-
Check that the functions are inverses:

∀ x -> f (g x) = x
∀ x -> g (f x) = x

let x = Inl (Pair x z)

compute:
f (g (Inl (Pair x z)))
== f (Pair (Inl x) z)
== (Inl (Pair x z))
-}


-- Note that Haskell does not understand precedence at the level of
-- type operators

-- Exponentials
{-
f' :: (Bool -> a)   ->  (a * a)
f' h = Pair (h False) (h True)

g' :: (a * a) -> (Bool -> a)
g' (Pair x y) = \b -> case b of
  False -> x
  True -> y

test2 :: (Bool -> a)   ≅  (a * a)
test2 = (f',g')
-}
--  (A+B) → C    ≅  (A → C) × (B → C)

f'' :: ((a+b) -> c)   ->  ((a -> c) * (b -> c))
f'' h = Pair (\x -> h (Inl x)) (\y -> h (Inr y))

g'' :: ((a -> c) * (b -> c)) -> ((a+b) -> c)
g'' (Pair ac bc) = \b -> case b of
  Inl x -> ac x
  Inr y -> bc y


test3 :: ((a+b) -> c)   ≅  ((a -> c) * (b -> c))
test3 = (f'',g'')


-- (de)Currification:
--  (A × B) → C  ≅  A → B → C

currify :: ((a * b) -> c) -> a -> b -> c
currify f x y = f (Pair x y)

uncurrify :: (a -> b -> c) -> ((a*b) -> c)
uncurrify g = \(Pair x y) -> g x y


-- Recursion

-- Example 1. List a = 1 + (a * List a)



-- What is a list?

-- Three possible models for types, three different answers:

-- 1. substitution model: Just expand the List equationv
{-
List a = 1 + (a * List a)
List a = 1 + (a * (1 + (a * List a)))
       = 1 + a * 1 + a * (a * List a)
       = 1 + a     + a^2 * List a
       = ...
       = 1 + a + a^2 + a^3 + ... + a^k + ...
-}



-- 2. (For the brave) use the algebraic model. ie. solve the equation
-- and do Taylor series expansion.)



-- 3. operational (von Neumann): Need an indirection

-- List a = 1 + (a * List a)
-- every recursive occurence must be accessed via a pointer.

-- In Haskell, recursive types must be introduced with 'data'. (No good reason)

-- type List a = One + (a * List a)

-- data List a = TagName (One + (a * List a))

data List a = Nil | Cons a (List a) 

-- data [a] = [] | (:) a [a]

sum' Nil = 0
sum' (Cons x xs) = x + sum' xs

sum [] = 0
sum (x:xs) = x + sum xs

append :: [a] -> [a] -> [a]
append [] ys = ys
append (x:xs) ys = x : append xs ys

reverse :: [a] -> [a]
reverse [] = []
reverse (x:xs) = reverse xs ++ [x]

-- In fact, there is special syntax for list based on colon, brackets and commas.

-- Example: sum, product of [Int]


-- Example 2. Bin a = 1 + (Bin a * a * Bin a)

