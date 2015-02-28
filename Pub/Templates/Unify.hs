import qualified Data.Map as M
import Data.Map (Map)


-- Variable representation?
-- Term representation?

-- Substitution?

-- Unification
-- unify :: (Term,Term) -> Substitution

-- Occurs check

-- Metavariables in a term
-- varsOf :: Terms -> [Variable]

-- occursIn :: Variable -> Term -> Bool

--------------------------------
-- Substitution management

-- | Identity (nothing is substituted)
-- idSubst = M.empty

-- | Add an "assignment" to a substitution
-- (+>) :: Substitution -> (Int, Term) -> Substitution

-- | Single substitution
-- (==>) :: Int -> Term -> Substitution

-- | Apply a substitution to a term
-- applySubst :: Substitution -> Term -> Term

------------
-- Tests

-- term1 = Con "Bin" [Con "Leaf" [Var "x"],
--                    Var "y"]

-- term2 = Con "Bin" [Con "Leaf" [Con "1"[]],
--                    Con "Bin" [Con "Leaf" [Var "x"]
--                              ,Con "Leaf" [Con "Leaf" [Con "3" []]]]]

-- testUnify = unify [(term1,term2)] M.empty
