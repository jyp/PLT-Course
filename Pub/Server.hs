import Control.Concurrent
import Control.Concurrent.Chan

data Connect = Connect (Chan Request) (Chan Reply)

type Reply = String
type Request = String 

------------------------------------------
-- Server code:

handleClient :: Chan Request -> Chan Reply -> IO ()
handleClient input output = do
  writeChan output "What is your name?"
  name <- readChan input
  writeChan output "What is your quest?"
  pass <- readChan input
  case name == "King Arthur" && pass == "Holy Grail"  of
    True  -> writeChan output "You shall pass!"
    False -> writeChan output "Incorrect login or password"
  
server :: Chan Connect -> IO ()
server c = do  
  Connect input output <- readChan c
  forkIO $ handleClient input output
  server c
    

-------------------------------------------
-- Startup code 

startServer :: IO (Chan Connect)
startServer = do  
  c <- newChan
  forkIO (server c)
  return c

-- connect a client; given the server to connect to
connectClient s = do
  inp <- newChan
  out <- newChan
  writeChan s (Connect inp out)
  return (inp,out)

-------------------------------------
-- Test run

main = do
  s <- startServer
  (i,o) <- connectClient s
  readChan o >>= putStrLn
  writeChan i "Sir Lancelot"
  readChan o >>= putStrLn    
  writeChan i "I seek the holy grail!"
  readChan o >>= putStrLn    

-- Exercise: start two clients concurrently.



