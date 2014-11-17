module Lang1 where

import Memory
data Op = Add | Sub | Mul | And | Or | Gt | Eq | Neq
  deriving (Show,Eq)

data Instruction = BinOp Op Ident Ident Ident --  arithmetic or logical operation
                 | Load Int Ident             --  load a constant to memory
                 | RelJump Ident Int          --  relative jump if the given memory location is not zero
                 | Print Ident
                 | Halt
  deriving (Show,Eq)
