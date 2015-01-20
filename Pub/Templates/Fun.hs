type Op = Int -> Int -> Int

data Expr = Val Value
          | Bin Op Expr Expr
            -- Var
            -- Lam
            -- App

data Value = Number Int

instance Show Value where
  show (Number x) = show x

eval = _
