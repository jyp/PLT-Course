


writeChan :: String -> Chan -> CP a -> CP a
writeChan s c = undefined


readChan :: Chan -> (String -> CP a) -> CP a
readChan = undefined


data Connect = Connect Chan Chan

------------------------------------------
-- Server code:

handleClient input output k = 
  writeChan output "What is your name?" $
  readChan input $ \name ->
  writeChan output "What is your quest?" $
  readChan input $ \pass -> 
  (case name /= "King Arthur" || pass /= "Holy Grail"  of
     False -> writeChan output "Incorrect login or password" 
     True  -> writeChan output "You shall pass!") $
  k
  
server c k = do  
  Connect input output <- readChan c
  forkIO $ handleClient input output
  server c k
    

------------------------------------------
-- Startup code (both for client and server

startServer = do  
  c <- newChan
  forkIO (server c)
  return c

-- start a client; given the server to connect to
startClient s = do
  inp <- newChan
  out <- newChan
  writeChan s (Connect inp out)
  return (inp,out)

-------------------------------------
-- Test run

main = do
  s <- startServer
  (i,o) <- startClient s
  readChan o >>= putStrLn
  writeChan i "Sir Lancelot"
  readChan o >>= putStrLn    
  writeChan i "I seek the holy grail!"
  readChan o >>= putStrLn    

-- Exercise: start two clients concurrently.

