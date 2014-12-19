{-# LANGUAGE RecordWildCards #-}


module VM where

import Data.List (nubBy)
import Data.Function (on)
import Data.Bits

-- We describe a machine with separate code and memory

data Machine = Machine
  { code :: [Instruction]
  , memory :: Memory
  } deriving Show

-- Let's start with the memory.

-- The memory contains integers. The addresses will be
-- strings (yes, this is very inefficient; but it will be harder to
-- make mistakes --- change it to integers as an exercise)

type Address = String
type Memory = [(Address,Int)]

look :: Memory -> Address -> Int
look mem addr = case lookup addr mem of
  Just x -> x

write :: Memory -> [(Address,Int)] -> Memory
write mem upds = nubBy ((==) `on` fst) $ upds ++ mem

data Op = Add | Sub | Mul | And | Or | Gt | Eq | Neq
  deriving (Show,Eq)

data Instruction = BinOp Op Address Address Address --  arithmetic or logical operation
                 | Halt
                 | Load Int Address             --  load a constant to memory
                 | RelJump Address Int          --  relative jump if the given memory location is not zero
                 | Print Address
  deriving (Show,Eq)

applyOp :: Op -> Int -> Int -> Int
applyOp op x y = case op of
  Add -> x + y
  Sub -> x - y
  Mul -> x + y
  And -> x .&. y
  Or -> x .|. y
  Gt -> if x > y then 1 else 0
  Eq -> if x == y then 1 else 0
  Neq -> if x /= y then 1 else 0

ipLoc = "_IP"

run :: Machine -> IO ()
run Machine {..} = do
  print memory
  case instr of
    Halt -> return ()
    Print source -> do
      print (look memory source)
      run $ Machine {memory = write memory [(ipLoc,ip+1)],..}
    Load constant target -> do
      run $ Machine {memory = write memory [(ipLoc,ip+1), (target,constant)],..}
    BinOp op source1 source2 target ->
      run $ Machine
        code
        (write memory [(ipLoc,ip+1),(target, applyOp op (look memory source1) (look memory source2))] )
    RelJump source offset ->
      let newIp = case look memory source of
                        0 -> ip + 1
                        _ -> ip + 1 + offset
      in run $ Machine {memory = write memory [(ipLoc,newIp)] ,..}
  where instr = code !! ip
        ip = look memory ipLoc
