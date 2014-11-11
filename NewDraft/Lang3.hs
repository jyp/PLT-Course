module Lang3 where

import Memory
import Lang1(Op(..))

data Expr = Var Ident | Bin Op Expr Expr | Neg Expr | Const Int | Call Ident [Expr]
data Instr = Assign Ident Expr | Print Expr | If Expr Instr Instr | Block [Instr]
data Decl = Function Ident [Ident] Instr
type Program = [Decl]
