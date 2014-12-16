-- Inspired by PLAI
-- Ch 7: reprise, with Higher-order stuff.
-- Ch 5. (Functions)


type Op = Int -> Int -> Int

data Expr = Val Val
          | Bin Op Expr Expr
          | App Expr Expr
          | Lam String Expr
          | Var String

data Val = Fun (Val -> Val)
         | Int Int

instance Show Val where
  show (Int x) = show x

eval :: Expr -> Val
eval (App f e) = let Fun f' = eval f in f' (eval e)
eval (Lam x e) = Fun $ \v -> (eval $ subst x v e)
eval (Val x) = x
eval (Bin op e1 e2) = let (Int x,Int y) = (eval e1,eval e2)
                      in Int $ op x y

subst :: String -> Val -> Expr -> Expr
subst what for e0 = case e0 of
  Lam x e | x == what -> Lam x e
  Lam x e | x /= what -> Lam x (subst what for e)
  App a b -> App (subst what for a) (subst what for b)
  Bin op a b -> Bin op (subst what for a) (subst what for b)
  Var x | x == what -> Val for
  Var x | x /= what -> Var x
  Val v -> Val v

one = Val $ Int 1
zero = Val $ Int 0
incr = Lam "x" $ Bin (+) (Var "x") one
twice = Lam "f" $ Lam "x" $ (App (Var "f") (App (Var "f") (Var "x")))

(@@) = App
main = print $ eval $ twice @@ twice @@ twice @@ incr @@ zero

-- subst :: String -> Expr -> Expr -> Expr
-- subst what for e0 = case e0 of
--   Var x -> if what == x then for else Var x
--   Num i -> Num i
--   Neg e -> Neg (subst what for e)
--   Plus e1 e2 -> Plus (subst what for e1) (subst what for e2)
--   Mult e1 e2 -> Mult (subst what for e1) (subst what for e2)
--   App e1 e2 -> App (subst what for e1) (subst what for e2)
--   Lam x e | what == x -> Lam x e
--           | otherwise -> let x' = if x `occursIn` for
--                                   then fresh [e,for]
--                                   else x
--              in Lam x' (subst what for $ subst x (Var x') e)

-- freeVars :: Expr -> [String]
-- freeVars e =

{-
-- Ch. 6. The environment
  

type Env = [(String,Val')]

data Val' = Int' Int | Fun' String Expr Env

eval' :: Env -> Expr -> Val'
eval' env (App f e) = let Fun' x b env' = eval' env f
                      in eval' ((x,eval' env e):env') b
eval' env (Lam x e) = Fun' x e env

-}
