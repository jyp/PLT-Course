import Text.Show
-- import Control.Arrow
import Data.List
import Prelude hiding (succ)
import Control.Applicative

type Sym = String
data Term = Var Sym | Lam Sym Term | App Term Term | Con String
--  deriving Show

instance Show Term where
    showsPrec d (Con x) = showString x
    showsPrec d (Var x) = showString x
    showsPrec d (Lam x t) = showParen (d > 0) (showString "\\" . showString x . showString "->" . showsPrec 0 t)
    showsPrec d (App t1 t2) = showParen (d > 1) (showsPrec 1 t1 . showString " " . showsPrec 2 t2)



subst :: Sym -> Term -> Term -> Term
subst v x b = sub b
  where sub e@(Var i) = if i == v then x else e
        sub (Con c) = Con c
        sub (App f a) = App (sub f) (sub a)
        sub (Lam i e) =
            if v == i then
                Lam i e
            else if i `elem` fvx then
                let i' = cloneSym e i
                    e' = substVar i i' e
                in  Lam i' (sub e')
            else
                Lam i (sub e)
        fvx = freeVars x
        cloneSym e i = loop i
           where loop i' = if i' `elem` vars then loop (i ++ "'") else i'
                 vars = fvx ++ freeVars e


substVar :: Sym -> Sym -> Term -> Term
substVar s s' e = subst s (Var s') e

freeVars :: Term -> [Sym]
freeVars (Var s) = [s]
freeVars (App f a) = freeVars f `union` freeVars a
freeVars (Lam i e) = freeVars e \\ [i]
freeVars (Con _) = []

data Subst a = Subst {old :: a, new :: a, didSomeThing :: Bool}

instance Functor Subst where
    fmap f = (pure f <*>)

instance Applicative Subst where
    f <*> x = Subst ((old f) (old x)) ((new f) (new x)) (didSomeThing f || didSomeThing x)
    pure f = Subst f f False

instance Alternative Subst where
    a <|> b = if didSomeThing a then a else b
    empty = error "gah"

betaRule t0@(App (Lam x t) (t')) = Subst t0 (subst x t' t) True
betaRule t0 = pure t0

applyLR rule (App t1 t2) = App <$> rule t1 <*> pure t2 <|> App <$> pure t1 <*> rule t2 
applyLR rule t = pure t

applyLeftMostOuterMost rule t =  rule t <|> applyLR (applyLeftMostOuterMost rule) t

iter :: (a -> Subst a) -> a -> [a]
iter rule t = if didSomeThing t' then t : iter rule (new t') else [t]
    where t' = rule t 

test = mapM_ print . iter (applyLeftMostOuterMost betaRule)    

(@@) = App
infixl @@

twice = Lam "f" $ Lam "x" $ (Var "f" @@ (Var "f" @@ Var "x"))

inc = Con "(1 +)"
zero = Con "0"

ex1 = twice @@ inc @@ zero
ex2 = twice @@ twice @@ inc @@ zero
ex3 = twice @@ (twice @@ twice) @@ inc @@ zero
ex4 = twice @@ twice @@ twice @@ inc @@ zero




