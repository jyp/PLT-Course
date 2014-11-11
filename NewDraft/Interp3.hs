module Interp3 where

import Lang1 (Op(..))
import Lang3
import Memory
import Machine (applyOp)

interpExpr :: Expr -> Memory -> IO (Int,Memory)
interpExpr (Var ident) mem = return (mem #! ident,mem)
interpExpr (Bin op x y) m0 = do
  (x',m1) <- interpExpr x m0
  (y',m2) <- interpExpr y m1
  return (applyOp op x' y',m2)
interpExpr (Neg y) m0 = interpExpr (Bin Sub (Const 0) y) m0
interpExpr (Const k) m = return (k,m)
interpExpr (Call id args) m0 = do
  (args',m1) <- interpExprs args m0


interpInstr :: Instr -> Memory -> IO Memory
interpInstr (Assign var x) m0 = do
  (x',m1) <- interpExpr x m0
  return (m1 #/ [(var,x')])
interpInstr (Print x) m0 = do
  (x',m1) <- interpExpr x m0
  print x'
  return m1
interpInstr (Block []) mem = return mem
interpInstr (Block (x:xs)) m0 = do
  m1 <- interpInstr x m0
  interpInstr (Block xs) m1
interpInstr (If x i1 i2) m0 = do
  (x',m1) <- interpExpr x m0
  if x' /= 0 then interpInstr i1 m1 else interpInstr i2 m1
