module ParserLibrary(  -- we specify the exported functions!
	value,
	satisfy,
	exactly,
	(|||),
	(@@),
	parse,
	(##),
	many,
	some
  ) where

import List

infixl 5 |||
infixl 6 @@, ##


type Parser a = String -> [(a,String)]

value :: a -> Parser a
value x s = [(x,s)]

satisfy :: (Char -> Bool) -> Parser Char
satisfy p (x:xs) = [(x, xs) | p x]
satisfy p [] = []

exactly :: String -> Parser String
exactly tok s = 
  [(tok,drop (length tok) s) | tok `isPrefixOf` s]

(|||) :: Parser a -> Parser a -> Parser a
(p ||| q) s = p s ++ q s

(@@) :: Parser (a->b) -> Parser a -> Parser b
(p @@ q) s =
  [(f x,s'') | (f,s') <- p s,
               (x,s'') <- q s']

parse :: Parser a -> String -> [a]
parse p s = [x | (x,"") <- p s]

(##) :: Parser a -> Parser b -> Parser a
p ## q = value const @@ p @@ q

many :: Parser a -> Parser [a]
many p = some p
     ||| value []

some :: Parser a -> Parser [a]
some p = value (:) @@ p @@ many p
