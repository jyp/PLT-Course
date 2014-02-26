module Search where

import Unify
import qualified Data.Map as M
import Data.List


-- type Proposition = 
-- type Equation = 

--------------------------------------------
-- Example 1: map coloring of south sweden
colors = ["Red","Green","Blue","Yellow"]

neighbour x y = Con "neighbour" [Var x,Var y]


ssw = Con "southSweden" (map Var ["bohus", "skane", "blekinge","sma","hal","dals","og","vg"])
{-
southSweden :: Equation
southSweden = (ssw,
             [n "skane" "blekinge",
              n "hal" "skane",
              n "hal" "sma",
              n "hal" "bohus",
              n "hal" "vg",
              n "bohus" "dals",
              n "bohus" "vg",
              n "vg" "sma",
              n "vg" "og",
              n "sma" "og",
              n "vg" "dals",
              n "bohus" "dals"])

-}

----------------------
-- Example 2: splitting a string by inverting append


-- nil =
-- cons x xs = 

append xs ys zs = Con "append" [xs,ys,zs]
char c = Con [c] []

-- stringToTerm = ...
-- termToString = ..

-- appendEqs :: [Equation]


-----------------
-- Interpreter

-- solve :: [Equation] -> Proposition -> [Substitution]


-- uniq :: Eq a => [a] -> [a]
-- uniqVarsOf :: Equation -> [Variable]




