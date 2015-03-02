module Search where

import Unify
import qualified Data.Map as M
import Data.List


type Equation = (Term,[Term])
-- Term: (x,[y1,y2,...,yn])
-- In curry syntax: x = y1 & y2 & ... & yn
-- In prolog syntax : x :- y1, y2, ... , yn
type Proposition = Term

uniqVarsOf :: Equation -> [Variable]
uniqVarsOf (t,ts) = nub $ concatMap varsOf (t:ts)

-- | Invent a fresh variable name
newName :: Variable -> Int -> (Variable,Term)
newName x i = (x,Var $ x ++ "_" ++ show i)

-- | Return the (possibly many) solutions to a set of equations.
-- Arguments:
-- i: current integer to get a fresh variable name
-- eqs: the equations to solve
-- ps: a set of propositions to satisfy
-- s: the current substitution
solve :: Int -> [Equation] -> [Proposition] -> Substitution -> [Substitution]
solve _i _eqs [] s = [s] -- No proposition to solve: done
solve i eqs (p:ps) s = do  -- Solving the 1st proposition
  eq <- eqs -- we can try any of the equations to "progress"
  let fvs = uniqVarsOf eq -- ! variable name clash !
      i' = i + length fvs
      newVars :: Substitution
      newVars = M.fromList $ zipWith newName fvs [i..]
      lhs = applySubst newVars $ fst eq -- we can prove the lhs
      rhs = map (applySubst newVars) $ snd eq -- as long as we prove all the rhs
  case unify2 lhs p of
    Nothing -> []
    Just s' -> solve i' eqs (map (applySubst s') (rhs++ps)) (s +> s')


------------------------------------------------------------------------------
--- Test: south sweden map
colors = ["Red","Green","Blue"]

neighbourEqs :: [Equation]
neighbourEqs = [(Con "neighbour" [Con x [], Con y []],[]) | x <- colors, y <- colors, x /= y]

ssw = Con "southSweden" (map Var ["bohus", "skane", "blekinge","sma","hal","dals","og","vg"])

southSweden :: Equation
southSweden = (ssw,
             [n "skane" "blekinge",
              n "hal" "skane",
              n "hal" "sma",
              n "hal" "bohus",
              n "hal" "vg",
              n "bohus" "dals",
              n "bohus" "vg",
              n "vg" "sma",
              n "vg" "og",
              n "sma" "og",
              n "vg" "dals",
              n "bohus" "dals"])
  where n x y = Con "neighbour" [Var x,Var y]

testSSW = head $ solve 0 (southSweden:neighbourEqs) [ssw] M.empty

-----------------------------------------------------------------------------
--- Test: append function
nil = Con "[]" []
cons x xs = Con ":" [x,xs]

append xs ys zs = Con "append" [xs,ys,zs]
char c = Con [c] []
string = foldr cons nil . map char
recoverString (Con "[]" []) = []
recoverString (Con ":" [Con [c] [], cs]) = c:recoverString cs

appendEqs :: [Equation]
appendEqs = [(append nil (Var "ys") (Var "ys"), []),
             (append (cons (Var "x") (Var "xs")) (Var "ys") (cons (Var "x") (Var "zs")),
              [append (Var "xs") (Var "ys") (Var "zs")])]

testAppend = [map (fmap recoverString . flip M.lookup sol) ["x","y"] | sol <- sols]
  where sols = solve 0 appendEqs [append (Var "x") (Var "y") (string "hello")] M.empty
