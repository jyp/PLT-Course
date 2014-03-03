import Data.Tree
import Text.Show
import Control.Arrow
import Data.List
import Prelude hiding (succ)

type Sym = String
data Term = Var Sym | Lam Sym Term | App Term Term | Con String
--  deriving Show

parens s = "("++s++")"

instance Show Term where
    showsPrec d (Con x) = showString x
    showsPrec d (Var x) = showString x
    showsPrec d (Lam x t) = showParen (d > 0) (showString "\\" . showString x . showString "->" . showsPrec 0 t)
    showsPrec d (App t1 t2) = showParen (d > 1) (showsPrec 1 t1 . showString " " . showsPrec 2 t2)

data Closure = Term :+ Env
  deriving Show
type Env = [(Sym,Closure)]
type State = (Closure, Stack)
type Stack = [Closure]

lookupEnv :: Sym -> Env -> Closure
lookupEnv x [] = error $ x ++ " not found in env!"
lookupEnv x ((y,v):rho) = if x == y then v else lookupEnv x rho

eval (Var x    :+ rho) s   = case lookup x rho of
  Just v -> eval v s
  Nothing -> foldl App (Var x) (map (flip eval []) s)
eval (Lam x t  :+ rho) (v:s) = eval (t :+ ((x,v):rho)) s
eval (Lam x t  :+ rho) []  = Lam x $ eval (t :+ rho) []
eval (App t1 t2 :+ rho) s  = eval (t1 :+ rho) ((t2 :+ rho):s)



i_ = Lam "x" (Var "x")

infixl `App`


zero = Lam "f" $ Lam "x" $ Var "x"
succ = Lam "n" $ Lam "f" $ Lam "x" $ ((Var "n") `App` (Var "f")) `App` ((Var "f") `App` (Var "x"))
two = succ `App` (succ `App` zero)
twice = Lam "f" $ Lam "x" $ (Var "f" `App` ( Var "f" `App` Var "x"))
_id = Lam "y" $ Var "y"

value1 = twice `App` _id
value2 = (twice `App` _id) `App` (Con "V")


delta = Lam "x" $ App (Var "x") (Var "x") 

s0 = (App delta delta, [], [])


