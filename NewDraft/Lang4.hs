module Lang4 where

import Memory
import Machine (applyOp)
import Lang1(Op(..))

data Expr = Var Ident | Bin Op Expr Expr | Const Int | Lam String Expr | App Expr Expr
  deriving Show
           
data Val = Int Int | Closure String Expr Env
  deriving Show
 

type Env = [(Ident,Val)]

-- instance Show Val where
--   show (Int i) = show i
--   show (Closure x t env) = "<<lambda>>"

eval :: Env -> Expr -> Val
eval env t = case t of
  Const i -> Int i
  Bin op e1 e2 -> case (eval env e1, eval env e2) of
    (Int e1',Int e2') -> Int $ applyOp op e1' e2'
    e12 -> error $ "type: " ++ show e12
  Var x -> case lookup x env of
    Just v -> v
    _ -> error "scope error"
  Lam x e -> Closure x e env
  App f a -> let a' = eval env a
                 f' = eval env f
               in case f' of
                 Closure x e env' -> eval ((x,a'):env') e
                 _ -> error "type error"


_let x e1 e2 = App (Lam x e2) e1
(@@) = App

example = _let "twice" (Lam "f" (Lam "x" (Var "f" @@ (Var "f" @@ Var "x")))) $
          _let "inc"  (Lam "x" (Bin Add (Var "x") (Const 1))) $
          (Var "twice" @@ Var "inc" @@ Const 123)

test1 = eval [] example
