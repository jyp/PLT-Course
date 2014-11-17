module Compil where

import qualified Machine as M
import Lang1 (Op(..))
import Memory
import qualified Lang1 as M
import Lang3

ip = Var M.ipLoc

compilExpr :: Int -> Expr -> (Ident, [M.Instruction], Int)
compilExpr m0 (Const 0) = ("_zero",[],m0)
compilExpr m0 (Const 1) = ("_one",[],m0)
compilExpr m0 (Const x) = (show m0,[M.Load x $ show m0],m0+1)
compilExpr m0 (Neg x) = compilExpr m0 (Bin Sub x (Const 1))
compilExpr m0 (Var x) = (x,[],m0)
compilExpr m0 (Bin op x y) =
  let (xloc,xcode,m1) = compilExpr m0 x
      (yloc,ycode,m2) = compilExpr m1 y
      zloc = show m2
      m3 = m2+1
  in (zloc,xcode++ycode++[M.BinOp op xloc yloc zloc],m3)

compileInstr :: Int -> Instr -> ([M.Instruction], Int)
compileInstr m0 (Print x) =
  let (xloc,xcode,m1) = compilExpr m0 x
  in (xcode++[M.Print xloc],m1)
compileInstr m0 (Assign loc x) =
  let (xloc,xcode,m1) = compilExpr m0 x
  in (xcode++[M.BinOp Add "_zero" xloc loc],m1)
compileInstr m0 (If x i1 i2) =
  let (xloc,xcode,m1) = compilExpr m0 (Neg x)
      (i1code,m2) = compileInstr m1 i1
      -- midCode = [M.Load (length i2code+1) m2, M.BinOp M.Add 0 m2 0]; m3 = m2+1
      (midCode,m3) = compileInstr m2 (Assign M.ipLoc $ Bin Add ip (Const $ length i2code+2))
      (i2code,m4) = compileInstr m3 i2
  in (xcode++[M.RelJump xloc (length (i1code++midCode))]++i1code++midCode++i2code,m4)

compileProgram :: Instr -> M.Machine
compileProgram i = M.Machine (M.mkCode $ [M.Load 0 "_zero",
                                          M.Load 1 "_one"] ++ code ++ [M.Halt])
                             M.initMemory
  where (code,_msize) = compileInstr 1000 i

runProgram :: Instr -> IO ()
runProgram = M.run . compileProgram


test = compileProgram $ If (Const 1) (Print $ Const 123) (Print $ Const 345)
