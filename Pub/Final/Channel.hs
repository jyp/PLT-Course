import Control.Concurrent
import Control.Concurrent.Chan

newStringChan :: IO (Chan String)
newStringChan = newChan

reader c = do
  s <- readChan c
  putStrLn $ "I have recieved: " ++ s
  reader c

writer c = do
  writeChan c "2"


main = do
  c <- newStringChan
  forkIO (reader c)
  writer c
