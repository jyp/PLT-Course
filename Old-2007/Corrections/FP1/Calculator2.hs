module Calculator2 where
import Char
import ParserLibrary

expr = term <**> exprRemainder

sign = value (+) ## symbol "+" 
       ||| value (flip (-)) ## symbol "-"

exprRemainder = chainr (value (.)) (sign @@ term) (value id)

chainr :: Parser (a -> a -> a) -> Parser a -> Parser a -> Parser a
chainr op p b = op @@ p @@ chainr op p b ||| b

term = value (*) @@ factor ## symbol "*" @@ factor
   ||| factor

factor = number 
     ||| value id ## symbol "(" @@ expr ## symbol ")"

number = white $ value (foldl combine 0) @@ some digit

combine x y = 10*x + y

digitval d = ord d - ord '0'
numval s = foldl combine 0 [digitval d | d <- s]

digit = value digitval @@ satisfy isDigit

infixl 6 <**>

(<**>) :: Parser a -> Parser (a->b) -> Parser b
k <**> f = value (\x g -> g x) @@ k @@ f


symbol = white . exactly
