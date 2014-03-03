module KAM where

import Text.Show
import Data.List
import Prelude hiding (succ)

type Sym = String
-- data Term = ...
--  deriving Show

-- instance Show Term where
--     showsPrec _ (Var x) = showString x
--     showsPrec d (Lam x t) = showParen (d > 0) (showString "\\" . showString x . showString "->" . showsPrec 0 t)
--     showsPrec d (App t1 t2) = showParen (d > 1) (showsPrec 1 t1 . showString " " . showsPrec 2 t2)



