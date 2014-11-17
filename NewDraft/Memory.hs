module Memory where

import Data.Map as M

type Ident = String
type Memory = M.Map Ident Int

mkMem us = emptyMem #/ us

emptyMem = M.empty
  
(#!) :: Memory -> String -> Int
(#!) = (M.!)

(#/) :: Memory -> [(String,Int)] -> Memory
mem #/ [] = mem
mem #/ ((k,v):upds) = M.insert k v mem #/ upds
