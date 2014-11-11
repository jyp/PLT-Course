module Lang1 where

import Memory
data Op = Add | Sub | Mul | And | Or | Gt | Eq | Neq
  deriving (Show,Eq)

data Instruction = BinOp Op Ident Ident Ident
                 | Load Int Ident
                 | RelJump Ident Int
                 | Print Ident
                 | Halt
  deriving (Show,Eq)
