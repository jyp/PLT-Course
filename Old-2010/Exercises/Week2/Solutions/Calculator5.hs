module Calculator where
import Char
import ParserLibrary

calc = parse expr

-- Q5: make the 2nd call a recursive call.
expr = value (+) @@ term ## exactly "+" @@ expr
   ||| term

term = value (*) @@ factor ## exactly "*" @@ term
   ||| factor

factor = value (^) @@ atom ## exactly "^" @@ factor
   ||| atom

atom = number 
     ||| value id ## exactly "(" @@ expr ## exactly ")"

number = value (foldl combine 0) @@ some digit

combine x y = 10*x + y

digitval d = ord d - ord '0'
numval s = foldl combine 0 [digitval d | d <- s]

digit = value digitval @@ satisfy isDigit
