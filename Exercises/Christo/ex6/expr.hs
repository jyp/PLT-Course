data Operator = Plus | Minus | Mul | Div
data Arith a =	  Num a
		| BinOp Operator (Arith a) (Arith a)



evalOp :: Num a => Operator -> a -> a -> (a -> r) -> r
evalOp x a b f = case x of
	Plus	-> f (a + b)
	Minus	-> f (a - b)
	Mul	-> f (a * b)


eval :: Num a => Arith a -> (a -> r) -> r
eval (Num a) f = f a
eval (BinOp op a b) f = eval a $ \num1 ->
			eval b $ \num2 ->
			evalOp op num1 num2 f


main = eval (BinOp Plus (BinOp Minus (Num 2) (Num 10)) (Num 22)) print
