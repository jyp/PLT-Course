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
write mem [] = mem
write mem ((addr,val):upds) = write (update mem addr val) upds

update :: Memory -> Address -> Int -> Memory
update []          addr val = [(addr,val)]
update ((a,x):axs) addr val | a == addr = (addr,val):axs
                            | otherwise = (a,x):update axs addr val

data Op = Add | Sub | Mul | And | Or | Gt | Eq | Neq
  deriving (Show,Eq)

data Instruction = BinOp Op Address Address Address
                   --  arithmetic or logical operation
                 | Halt
                   -- stop the machine
                 | Print Address
                   -- print the contents of a given memory location
                 | Load Int Address
                   --  load a constant to memory
                 | RelJump Address Int
                   --  relative jump if the given memory location is not zero
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
        (write memory [(ipLoc,ip+1),
                       (target, applyOp op (look memory source1)
                                           (look memory source2))])
    RelJump source offset ->
      let newIp = case look memory source of
                        0 -> ip + 1
                        _ -> ip + 1 + offset
      in run $ Machine {memory = write memory [(ipLoc,newIp)] ,..}
  where instr = code !! ip
        ip = look memory ipLoc

initMemory :: Memory
initMemory = [(ipLoc,0)]

exCalc = Machine [BinOp Sub "z" "x" "y", Halt] [(ipLoc,0),("x",1000),("y",10)]
exLoop = Machine
         [Load 0 "zero"
         ,Load 1 "one"
         ,Load 1000 "counter"
         ,Print "counter"
         ,BinOp Sub "counter" "one" "counter"
         ,BinOp Neq "counter" "zero" "cond"
         ,RelJump "cond" (-4)
         ,Halt]
         initMemory

main :: IO ()
main = run exLoop
