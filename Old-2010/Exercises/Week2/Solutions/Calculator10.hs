module Calculator where
import Char
import ParserLibrary

calc = parse expr

-- Q10: exactly -> symbol; number -> white numberCl
symbol tok = white (exactly tok)

expr = value (+) @@ term ## symbol "+" @@ expr
   ||| term

term = value (*) @@ factor ## symbol "*" @@ term
   ||| factor

factor = value (^) @@ atom ## symbol "^" @@ factor
   ||| atom

atom = white number 
     ||| value id ## symbol "(" @@ expr ## symbol ")"

number = value (foldl combine 0) @@ some digit

combine x y = 10*x + y

digitval d = ord d - ord '0'
numval s = foldl combine 0 [digitval d | d <- s]

digit = value digitval @@ satisfy isDigit
