import Control.Concurrent
import Control.Concurrent.Chan



data Connect = Connect (Chan Request) (Chan Reply)

type Reply = String

-- The client can only "tell" these two things to the server:
type Request = String 

------------------------------------------
-- Server code:

handleClient input output = do
  writeChan output "What is your name?"
  name <- readChan input
  writeChan output "What is your quest?"
  pass <- readChan input
  case name == "King Arthur" && pass == "Holy Grail"  of
    True  -> writeChan output "You shall pass!"
    False -> writeChan output "Incorrect login or password"
  
server c = do  
  Connect input output <- readChan c
  forkIO $ handleClient input output
  server c
    

-------------------------------------------
-- Startup code 

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



