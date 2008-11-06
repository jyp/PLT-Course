module Calculator where
import Char
import ParserLibrary

calc = parse expr

expr = value (+) @@ term ## exactly "+" @@ term
   ||| term

term = value (*) @@ factor ## exactly "*" @@ factor
   ||| factor

-- Q4 (old factor becomes atom)
factor = value (^) @@ atom ## exactly "^" @@ atom
   ||| atom

atom = number 
     ||| value id ## exactly "(" @@ expr ## exactly ")"

number = value (foldl combine 0) @@ some digit

combine x y = 10*x + y

digitval d = ord d - ord '0'
numval s = foldl combine 0 [digitval d | d <- s]

-- Q3
digit = value digitval @@ satisfy isDigit
-- digit s = [(digitval d,s') | (d,s') <- satisfy isDigit s]
