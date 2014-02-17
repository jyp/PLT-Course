import Control.Concurrent
import Control.Concurrent.Chan

-- API:
-- newChan :: IO (Chan a)
-- readChan :: Chan a -> IO a
--  writeChan c "2"
 
-- TODO:

-- create a channel (pick a monotype)
-- create a process writing on it
-- create a process reading the value and printing it.

-- run the processes concurrently
