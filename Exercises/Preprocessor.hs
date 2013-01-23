{-# LANGUAGE RecordWildCards #-}
  
module Main where

import Data.Maybe
import System.Environment

data Status = Status {transmit :: Maybe String, inAnswer :: Bool, answersDeactivated :: Bool}

updStatus Status {..} s
  | s == "\\begin{ans}" && answersDeactivated = Status {transmit = Nothing, inAnswer = True, ..}
  | s == "\\end{ans}"   && answersDeactivated = Status {transmit = Nothing, inAnswer = False, ..}
  | s == "\\DeactivateAnswers" = Status {transmit = Nothing, answersDeactivated = True, ..}
  | inAnswer = Status {transmit = Nothing, ..}
  | otherwise = Status {transmit = Just s, ..}

main = do
  [f,g] <- getArgs
  x <- readFile f
  let y = unlines . catMaybes . map transmit $ scanl updStatus (Status Nothing False False) . lines $ x
  writeFile g y
  
  