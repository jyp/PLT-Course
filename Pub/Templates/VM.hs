{-# LANGUAGE RecordWildCards #-}


module VM where

import Data.List (nubBy)
import Data.Bits

-- We describe a machine with separate code and memory

data Machine = Machine
  { code :: _
  , memory :: _
  } deriving Show


type Address = _
type Memory = _

look :: Memory -> Address -> Int
look mem addr = case lookup addr mem of
  Just x -> x

write :: Memory -> [(Address,Int)] -> Memory
write mem upds = nubBy ((==) `on` fst) $ upds ++ mem

data Op = _
  deriving (Show,Eq)

data Instruction = Halt -- stop the machine
  deriving (Show,Eq)

run :: Machine -> IO ()
run Machine {..} = do
  print memory
  case instr of
    Halt -> return ()
