\begin{code}
module Calculator where
import Char
import ParserLibrary

calc = parse expr

-- Q10: exactly -> symbol; number -> white number

-- Q5: make the 2nd call a recursive call.
expr = value (+) @@ term ## symbol "+" @@ expr
   ||| term

term = value (*) @@ factor ## symbol "*" @@ term
   ||| factor

-- Q4 (old factor becomes atom)
factor = value (^) @@ atom ## symbol "^" @@ factor
   ||| atom

atom = white number 
     ||| value id ## symbol "(" @@ expr ## symbol ")"

number = value (foldl combine 0) @@ some digit

combine x y = 10*x + y

digitval d = ord d - ord '0'
numval s = foldl combine 0 [digitval d | d <- s]

-- Q3
digit = value digitval @@ satisfy isDigit
-- digit s = [(digitval d,s') | (d,s') <- satisfy isDigit s]
\end{code}