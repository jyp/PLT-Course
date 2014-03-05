module KAM where

import Text.Show
import Data.List
import Prelude hiding (succ)

type Variable = String

data Term = Var Variable | App Term Term | Lam Variable Term
 -- deriving Show

instance Show Term where
    showsPrec _ (Var x) = showString x
    showsPrec d (Lam x t) = showParen (d > 0) (showString "\\" . showString x . showString "->" . showsPrec 0 t)
    showsPrec d (App t1 t2) = showParen (d > 1) (showsPrec 1 t1 . showString " " . showsPrec 2 t2)


-- zero = Lam "f" $ Lam "z" $ Var "z"
zero = Lam "c" $ Lam "n" $ Var "n"
succ = Lam "xs" $ Lam "c" $ Lam "n" $
           App (Var "c") (Var "xs" `App` Var "c" `App` Var "n")
one = succ `App` zero

-- append :: List a -> List a -> List a
plus = Lam "xs" $ Lam "ys" $ Var "xs" `App` succ `App` Var "ys"

two = plus `App` one `App` one

infixl `App`

type Stack = [Closure]
type Env = [(Variable,Closure)]
data Closure = C Term Env

eval :: Stack -> Closure -> Term
eval s      (C (Var x)   env) = case lookup x env of
  Nothing -> foldl App (Var x) (map (eval []) s)
  Just  c -> eval s c
eval (s:ss) (C (Lam x t) env) = eval ss (C t ((x,s):env))
eval []     (C (Lam x t) env) = Lam x $ eval [] (C t env)
eval s      (C (App t u) env) = eval (C u env:s) (C t env)

eval' t = eval [] (C t [])

-- Closures?
