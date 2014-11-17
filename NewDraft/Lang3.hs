module Lang3 where

import Memory
import Lang1(Op(..))

data Expr = Var Ident | Bin Op Expr Expr | Neg Expr | Const Int
data Instr = Assign Ident Expr | Print Expr | If Expr Instr Instr | Block [Instr]
           | Call Ident [Ident] [Expr]
data Decl = Procedure [Ident] [Ident] Instr
type Library = [(Ident,Decl)]
