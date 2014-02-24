module Unify where

import qualified Data.Map as M
import Data.Map (Map)

type Variable = String

-- Variable representation?
-- Term representation?
data Term = Con String [Term]
          | Var Variable -- metavar
  deriving (Show)
-- Substitution?

type Substitution = Map String Term

both :: (t -> t1) -> (t, t) -> (t1, t1)
both f (x,y) = (f x, f y)

-- Unification
unify :: [(Term,Term)] -> Substitution -> Maybe Substitution
-- Invariant: if x appears in the (source) of the substitution, then it does not
-- occur anywhere in the constraints.
unify [] s = Just s
unify ((Con c1 args1,Con c2 args2):constraints) s
  | c1 /= c2 = Nothing
  | otherwise
  -- lengths args1 == lengths args2
  = unify (zip args1 args2++constraints) s
unify ((Var x,Var x'):constraints) s -- FIX
  | x == x' = unify constraints s
unify ((Var x,t):constraints) s
  | x `occursIn` t = Nothing
  | otherwise
  = unify (map (both (applySubst (x==>t) {- (s) FIX -})) constraints) (s +> (x ==> t))
unify ((t,Var x):cs) s = unify ((Var x,t):cs) s

term1 = Con "Bin" [Con "Leaf" [Var "x"],
                   Var "y"]

term2 = Con "Bin" [Con "Leaf" [Con "1"[]],
                   Con "Bin" [Con "Leaf" [Var "x"]
                             ,Con "Leaf" [Con "Leaf" [Con "3" []]]]]

testUnify = unify [(term1,term2)] M.empty


--------------------
-- Occurs check

-- Metavariables in a term
varsOf :: Term -> [Variable]
varsOf (Var x) = [x]
varsOf (Con _ args) = concat $ map varsOf args

occursIn :: Variable -> Term -> Bool
occursIn v t = v `elem` varsOf t

--------------------------------
-- Substitution management

-- | Identity (nothing is substituted)
-- idSubst = M.empty

-- | Add an "assignment" to a substitution
(+>) :: Substitution -> Substitution -> Substitution
bigS +> smallS = M.union (applySubst smallS `fmap` bigS) smallS

-- | Single substitution
(==>) :: String -> Term -> Substitution
x ==> t = M.singleton x t

-- | Apply a substitution to a term
applySubst :: Substitution -> Term -> Term
applySubst s (Var x) = case M.lookup x s of
  Nothing -> Var x
  Just t -> t
applySubst s (Con cname args) = Con cname (map (applySubst s) args)

unify2 s t = unify [(s,t)] M.empty
