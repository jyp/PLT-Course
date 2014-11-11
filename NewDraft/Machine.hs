{-# LANGUAGE RecordWildCards #-}
module Machine where

import Data.Array
import Data.Bits
import Control.Monad (forM_)
import qualified Data.Map as M
import Lang1
import Memory

data Machine = Machine
  { code :: Array Int Instruction
  , memory :: Memory
  } deriving Show

ipLoc :: Ident
ipLoc = "_IP"

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

run :: Machine -> IO ()
run Machine {..} = do
  print memory
  case instr of
    Halt -> return ()
    Print source -> do
      print (memory M.! source)
      run $ Machine {memory = memory #/ [(ipLoc,ip+1)],..}
    Load constant target -> do
      run $ Machine {memory = memory #/ [(ipLoc,ip+1), (target,constant)],..}
    BinOp op source1 source2 target ->
      run $ Machine
        code
        (memory #/ [(ipLoc,ip+1),(target, applyOp op (memory #! source1) (memory #! source2))])
    RelJump source offset ->
      let newIp = case memory #! source of
                        0 -> ip + 1
                        _ -> ip + 1 + offset
      in run $ Machine {memory = memory #/ [(ipLoc,newIp)] ,..}
  where instr = code ! ip
        ip = memory #! ipLoc

mkCode :: [a] -> Array Int a
mkCode xs = listArray (0,length xs-1) xs

printCode :: Machine -> IO ()
printCode Machine{..} =
  forM_ (assocs code) $ \(i,e) -> putStrLn $ show i ++ ": " ++ show e

main :: IO ()
main = run $ Machine
               (mkCode [Load 0 "zero"
                       ,Load 1 "one"
                       ,Load 1000 "counter"
                       ,Print "counter"
                       ,BinOp Sub "counter" "one" "counter"
                       ,BinOp Neq "counter" "zero" "cond"
                       ,RelJump "cond" (-4)
                       ,Halt])
               initMemory

initMemory :: Memory
initMemory = M.singleton ipLoc 0
