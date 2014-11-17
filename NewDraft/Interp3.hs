module Interp3 where

import Lang1 (Op(..))
import Lang3
import Memory
import Machine (applyOp)

interpExpr :: Expr -> Memory -> Int
interpExpr (Var ident) mem = mem #! ident
interpExpr (Bin op x y) m0 = applyOp op (interpExpr x m0) (interpExpr y m0)
interpExpr (Neg y) m0 = interpExpr (Bin Sub (Const 0) y) m0
interpExpr (Const k) m = k

interpInstr :: Library -> Instr -> Memory -> IO Memory
interpInstr env (Assign var x) m0 = do
  return (m0 #/ [(var,interpExpr x m0)])
interpInstr env (Print x) m0 = do
  let x' = interpExpr x m0
  print x'
  return m0
interpInstr env (Block []) mem = return mem
interpInstr env (Block (x:xs)) m0 = do
  m1 <- interpInstr env x m0
  interpInstr env (Block xs) m1
interpInstr env (If x i1 i2) m0 = do
  let x' = interpExpr x m0
  if x' /= 0 then interpInstr env i1 m0 else interpInstr env i2 m0
interpInstr env (Call f byRefArgs byValArgs) m0 = do
  let args' = map (flip interpExpr m0) byValArgs
  case lookup f env of
    Just (Procedure byRefParams byValParams body) ->
      interpInstr env
                  (substInstrId (zip byRefParams byRefArgs)
                   (substInstrVal (zip byValParams args') body))
                  m0
    Nothing -> error "procedure not found"



type Subst a = [(Ident,a)]
type IdSubst = Subst Ident
type ValSubst = Subst Int

substId :: IdSubst ->  Ident -> Ident
substId s x = case lookup x s of
  Nothing -> x
  Just x' -> x'

substExprId :: IdSubst -> Expr -> Expr
substExprId s e = case e of
  Var i -> Var $ substId s i
  Bin op e1 e2 -> Bin op (substExprId s e1) (substExprId s e2)
  Neg e1 ->  Neg (substExprId s e1)
  Const x ->  Const x

substInstrId :: IdSubst -> Instr -> Instr
substInstrId s i = case i of
  Assign x e -> Assign (substId s x) (substExprId s e)
  Print e -> Print $ substExprId s e
  If e i1 i2 -> If (substExprId s e) (substInstrId s i1)(substInstrId s i2)
  Block is -> Block [substInstrId s i' | i' <- is]
  Call f ras vas -> Call f (map (substId s) ras) (map (substExprId s) vas)

substExprVal :: ValSubst -> Expr -> Expr
substExprVal s e = case e of
  Var i -> case lookup i s of
    Nothing -> Var i
    Just x -> Const x
  Bin op e1 e2 -> Bin op (substExprVal s e1) (substExprVal s e2)
  Neg e1 ->  Neg (substExprVal s e1)
  Const x ->  Const x

substInstrVal :: ValSubst -> Instr -> Instr
substInstrVal s i = case i of
  Assign x e -> Assign x (substExprVal s e)
  Print e -> Print $ substExprVal s e
  If e i1 i2 -> If (substExprVal s e) (substInstrVal s i1)(substInstrVal s i2)
  Block is -> Block [substInstrVal s i' | i' <- is]
  Call f ras vas -> Call f ras (map (substExprVal s) vas)


lib = [("swap",Procedure ["x","y"] [] $
               Block [Assign "tmp" (Var "x")
                     ,Assign "x" (Var "y")
                     ,Assign "y" (Var "tmp")
                     ])]

sortTwo = If (Bin Gt (Var "a") (Var "b")) (Call "swap" ["a","b"] []) (Block [])

example = interpInstr lib sortTwo (mkMem [("a",1123),("b",234)])
