import Control.Concurrent
import Control.Concurrent.Chan


data Connect = Connect (Chan Request) (Chan Reply)

data Request = Login String 
             | Password String 
             | Store (String,String) 
             | Retrieve String

handleClient input output = do
  writeChan output "What is your name?"
  Login name <- readChan input
  writeChan output "What is your quest?"
  Password pass <- readChan input
  case pass == "" of
    False -> writeChan output "Incorrect login or password"
    True  -> writeChan output
  
  
server c = do  
  Connect input output <- readChan 
  handleClient input output
  server c
    
startServer = do  
  c <- newChan
  forkIO (server c)
  return c