\begin{code}

module ParserLibrary(  -- we specify the exported functions
        Parser,               
	value,
	satisfy,
	exactly,
	(|||),
	(@@),
	parse,
	(##),
	($$),
	many,
	some,
	many',
	some',
        white
  ) where

import List
import Data.Char

infixl 5 |||
infixl 6 @@, ##

-- Parsers are represented by functions according to the following
-- type definition:

type Parser a = String -> [(a,String)]

-- These functions *depend on the representation of Parsers*

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
  [(f x,s'') |  (f,s') <- p s,
                (x,s'') <- q s']

parse :: Parser a -> String -> [a]
parse p s = [x | (x,"") <- p s]

-- From this point on, the code *does not* depend on the representation
-- of Parsers--so if it is changed, then the code below should still work.

(##) :: Parser a -> Parser b -> Parser a
p ## q = value const @@ p @@ q

many :: Parser a -> Parser [a]
many p = some p
     ||| value []

some :: Parser a -> Parser [a]
some p = value (:) @@ p @@ many p

---------


-- Q 9
($$) :: Parser a -> Parser b -> Parser b
p $$ q = value (\x y->y) @@ p @@ q

white p = many (satisfy isSpace) $$ p


-- Q 11
fails :: Parser a -> Parser ()
fails p = \input -> case p input of
                      [] -> value () input
                      _ -> []

-- Q 12
some' p = value (:) @@ p @@ many' p
many' p = (value [] ## fails p) ||| some' p

\end{code}


