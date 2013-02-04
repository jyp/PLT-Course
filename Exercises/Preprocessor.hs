{-# LANGUAGE RecordWildCards #-}
  
module Main where

import Data.Maybe
import System.Environment
import Data.List

data Status = Status {transmit :: Maybe String, inAnswer :: Bool, answersDeactivated :: Bool}

updStatus Status {..} s
  | ("\\begin{ans}" `isInfixOf` s) && answersDeactivated = Status {transmit = Nothing, inAnswer = True, ..}
  | ("\\end{ans}" `isInfixOf` s) && answersDeactivated = Status {transmit = Nothing, inAnswer = False, ..}
  | ("\\DeactivateAnswers" `isInfixOf` s) && not ("newcommand\\DeactivateAnswers" `isInfixOf` s) 
     = Status {transmit = Nothing, answersDeactivated = True, ..}
  | inAnswer = Status {transmit = Nothing, ..}
  | otherwise = Status {transmit = Just s, ..}

main = do
  [f,g] <- getArgs
  x <- readFile f
  let y = unlines . catMaybes . map transmit $ scanl updStatus (Status Nothing False False) . lines $ x
  writeFile g y
  