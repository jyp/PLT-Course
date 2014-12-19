type Op = Int -> Int -> Int

data Expr = Val Value
          | Bin Op Expr Expr
          | App Expr Expr
          | Lam String Expr
          | Var String

data Value = Fun (Value -> Value)
           | Number Int

instance Show Value where
  show (Number x) = show x

eval :: Expr -> Value
eval e0 = case e0 of
  App f e -> let Fun f' = eval f in f' (eval e)
  Lam x e -> Fun (\v -> eval (subst x v e))
  Val x -> x
  Bin op e1 e2 -> let (Number x,Number y) = (eval e1,eval e2)
                    in Number $ op x y

subst :: String -> Value -> Expr -> Expr
subst what for e0 = case e0 of
  Lam x e | x == what -> Lam x e
  Lam x e | x /= what -> Lam x (subst what for e)
  App a b -> App (subst what for a) (subst what for b)
  Bin op a b -> Bin op (subst what for a) (subst what for b)
  Var x | x == what -> Val for
  Var x | x /= what -> Var x
  Val v -> Val v

one = Val $ Number 1
zero = Val $ Number 0
incr = Lam "x" $ Bin (+) (Var "x") one
twice = Lam "f" $ Lam "x" $ (App (Var "f") (App (Var "f") (Var "x")))

(@@) = App
main = print $ eval $ twice @@ twice @@ twice @@ incr @@ zero

