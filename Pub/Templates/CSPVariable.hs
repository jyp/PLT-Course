
module CSPVar where

import Control.Concurrent

-- API: 
-- type Variable a = () -- TODO
-- newVariable :: a -> IO (Variable a)
-- set :: Variable a -> a -> IO ()
-- get :: Variable a -> IO a

-- Example use:
-- main = do
--   v <- newVariable "initial value"
--   set v "new value"
--   get v >>= putStrLn



-- Idea: have a process managing the variable.
-- The variable is represented by the channel that the process is listening to.
