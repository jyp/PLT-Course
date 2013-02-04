module Ex51and52 where

data Expr
    = Lit Int
    | Add Expr Expr
    | Mul Expr Expr
    | Var String

eval :: [(String,Int)] -> Expr -> Expr
eval env (Lit x)   = x
eval env (Add u v) = eval env u + eval env v
eval env (Mul u v) = eval env u * eval env v
eval env (Var v)   = case lookup v env of
    Just x  -> x
    Nothing -> error $ "Unbound variable " ++ show x

