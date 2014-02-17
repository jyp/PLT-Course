import Control.Concurrent
import Control.Concurrent.Chan




data Query = Call Int (Chan Int)

serverFunction n = product [1..n]

server :: Chan Query -> IO ()
server c = do
  q <- readChan c 
  case q of
    Call argument resultChan -> do 
           let result = serverFunction argument 
           -- !!! force evaluation of result in the server
           writeChan resultChan result
           server c

createServer :: IO (Chan Query)
createServer = do
  c <- newChan
  forkIO (server c)
  return c

remoteCall :: Chan Query -> Int -> IO Int
remoteCall c argument = do
  replyChan <- newChan
  writeChan c (Call argument replyChan)
  result <- readChan replyChan
  return result

main = do
  c <- createServer
  remoteCall c 5



