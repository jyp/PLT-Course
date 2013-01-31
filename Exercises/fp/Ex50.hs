module Ex50 where

data Tree a = Branch (Tree a) a (Tree a) | Empty

