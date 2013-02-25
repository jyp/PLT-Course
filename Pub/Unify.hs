import qualified Data.Map as M
import Data.Map (Map)

data Term = Con String [Term] -- the terms are the arguments to the constant
          | Var Int -- metavariable

type Substitution = Map Int Term

both f (x,y) = (f x, f y)

unify :: [(Term,Term)] -> Substitution -> Maybe Substitution
unify [] s = Just s -- Base case
unify ((t,t'):ts) | t == t' = unify ts t
unify ((Con f as,Con g bs):ts) s
  | f == g && length as == length bs = unify (zip as bs ++ ts) s
  | otherwise = Nothing -- Clash
unify ((Var x,t):ts) s
  | x `occursIn` t = Nothing -- Occurs check
  | otherwise      = unify (map (both (applySubst (x ==> t))) ts) (s +> (x,t))
unify ((t, Var x):ts) s = unify ((Var x, t):ts) s -- Re-orient

-------------------
-- Occurs check

varsOf (Var x) = [x]
varsOf (Con _ xs) = concatMap varsOf xs

occursIn x t = x `elem` varsOf t

--------------------------------
-- Substitution management

-- | Identity (nothing is substituted)
idSubst = M.empty

-- | Add an "assignment" to a substitution
(+>) :: Substitution -> (Int, Term) -> Substitution
s +> (x,t) = M.insert x t (M.map (applySubst (x ==> t)) s)

-- | Single substitution
(==>) :: Int -> Term -> Substitution
x ==> t = M.singleton x t

-- | Apply a substitution to a term
applySubst :: Substitution -> Term -> Term
applySubst f (Var i) = case M.lookup i f of
                          Nothing -> Var i
                          Just t -> t
applySubst f (Con c xs) = Con c (map (applySubst f) xs)
