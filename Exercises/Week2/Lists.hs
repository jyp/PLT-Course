module Lists where

import Control.Monad
import Test.QuickCheck
import Data.Char

import ParserLibrary

string :: [Int] -> String
list :: String -> [([Int],String)]

-- The result of string xs should be the same as show xs
prop_string_as_show s = string s == show s

-- The result of parsing the result of string should be
-- the same as the input to string
prop_list_parse_string l = parse list (string l) == [l]

string [] = "[]"
string (x:xs) = "[" ++ show x ++ commaString xs ++ "]"
commaString [] = ""
commaString (x:xs) = "," ++ show x ++ commaString xs

list = value [] ## exactly "[]"
   ||| value (:) ## exactly "[" @@ signed @@ many commaSigned ## exactly "]"

commaSigned = value id ## exactly "," @@ signed
signed = value negate ## exactly "-" @@ number ||| number

number = value (foldl combine 0) @@ some digit

combine x y = 10*x + y
digitval d = ord d - ord '0'
numval s = foldl combine 0 [digitval d | d <- s]
digit s = [(digitval d,s') | (d,s') <- satisfy isDigit s]

fails p s =
  case p s of
    [] -> [((),s)]
    _ -> []
