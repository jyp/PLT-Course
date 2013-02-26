import qualified Data.Map as M
import Data.Map (Map)

data Term = Con String [Term] -- the terms are the arguments to the constant
          | Var Int -- metavariable
  deriving Eq

type Substitution = Map Int Term

both f (x,y) = (f x, f y)

-- Specification: after applying the returned substitution, every
-- assertion made in the input (1st argument) will be verified. That
-- is the 1st elemet of the pair will be syntactically equal to the
-- second element.
unify :: [(Term,Term)] -> Substitution -> Maybe Substitution
unify [] s = Just s -- Base case
unify ((t,t'):ts) s | t == t' = unify ts s
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
