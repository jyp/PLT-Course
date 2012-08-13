-- Exercise 48 Define an algebraic type for binary trees
data Tree a = Tree a (Tree a) (Tree a)



-- Exercise 49 define an algebraic type for arithmetic expressions
data Operator = Plus | Minus | Mul | Div
data Arith a =	  Num a
		| BinOp Operator (Arith a) (Arith a)



-- Exercise 50 define a simple interpreter for the above type
evalOp :: Numa a => Operator -> (a -> a -> a)
evalOp x = case x of
	Plus	= (+)
	Minus	= subtract
	Mul	= (*)
	Div	= (/)

eval :: Num a => Arith a -> a
eval (Num a) = a
eval (BinOp op a b) = (evalOp op) (evalC a) (evalC b)


--Exercise 51 Translate the above 2 structures to an OO language. (Hint:
-- One class corresponds to leaves, one to branching.)
-- C++:
template <class T>
class Tree {
	Tree<T> *left, *right;
	T value;
};

-- Arith in monsterfile




--Exercise 54 Define a function f following this spec: given a integer, return
--  it unchanged if it is greater than zero, and zero otherwise. (The type must be
--  Int → Int.)
-- And 55

f :: Int -> Int
f n | n > 0     = n
    | otherwise = 0

-- Exercise 55 Assuming a function max : (Int × Int) → Int, define the function f.

f n = max (0, n)



-- Exercise 58
-- Unfold the following expressions:
1. map f                 makes negative elements zero in a list
2. filter (>= 0)         removes negative elements in a list
3. foldr [] (++)         concatenates  a list of strings to one string



-- Exercise 59
-- How would the same algorithm be naturally expressed in a
-- functional language? (Use functions from the Haskell prelude to shorten your
-- code)

f = filter (>= 24)

