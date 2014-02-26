module Search where

import Unify
import qualified Data.Map as M
import Data.List


type Equation = (Term,[Term]) -- x = y3 & y2 & ... & yn
type Proposition = Term

uniq :: Eq a => [a] -> [a]
uniq = map head . group

uniqVarsOf :: Equation -> [Variable]
uniqVarsOf (t,ts) = uniq $ sort $ concatMap varsOf (t:ts)

newName :: Variable -> Int -> (Variable,Term)
newName x i = (x,Var $ x ++ "_" ++ show i)

solve :: Int -> [Equation] -> [Proposition] -> Substitution -> [Substitution]
solve _i _eqs [] s = [s]
solve i eqs (p:ps) s = do
  eq <- eqs
  let fvs = uniqVarsOf eq
      i' = i + length fvs
      newVars :: Substitution
      newVars = M.fromList $ zipWith newName fvs [i..]
      lhs = applySubst newVars $ fst eq
      rhs = map (applySubst newVars) $ snd eq
  case unify2 lhs p of
    Nothing -> []
    Just s' -> solve i' eqs (map (applySubst s') (rhs++ps)) (s +> s')

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

nil = Con "[]" []
cons x xs = Con ":" [x,xs]

append xs ys zs = Con "append" [xs,ys,zs]
char c = Con [c] []
string = foldr cons nil . map char
recoverString (Con "[]" []) = []
recoverString (Con ":" [Con [c] [], cs]) = c:recoverString cs

appendEqs :: [Equation]
appendEqs = [(append nil (Var "ys") (Var "ys"), []),
             (append (cons (Var "x") (Var "xs")) (Var "ys") (cons (Var "x") (Var "zs")), [append (Var "xs") (Var "ys") (Var "zs")])]

testSSW = head $ solve 0 (southSweden:neighbourEqs) [ssw] M.empty

testAppend = [map (fmap recoverString . flip M.lookup sol) ["x","y"] | sol <- sols]
  where sols = solve 0 appendEqs [append (Var "x") (Var "y") (string "hello")] M.empty
