import Text.Groom
import RuntimeSystem

data Connect = Connect Chan Chan
-- We only support transmission of Strings here

------------------------------------------
-- Server code:

handleClient :: Chan -> Chan -> Process
handleClient input output = 
  writeChan output "User name:" (
  readChan input ( \name ->
  writeChan output "Password:" (
  readChan input ( \pass -> 
  (case name == "King Arthur" && pass == "Holy Grail"  of
     False -> writeChan output "Incorrect login or password" die
     True  -> writeChan output "You shall pass!" die)
  ))))
  

server c k = 
  readChan c $ \chs ->
  let [d1,d2] = chs 
      input  = read [d1]
      output = read [d2]
      -- This code differs because we only support string channels
  in fork (handleClient input output) $
     server c k
    
-------------------------------------------
-- Startup code 
     
startServer :: (Chan -> Process) -> Process
startServer k = 
  newChan $ \c ->
  fork (server c die) $
  k c

-- connect a client; given the server to connect to
connectClient c k = 
  newChan $ \inp ->
  newChan $ \out ->
  writeChan c (show inp ++ show out) $
  k (inp,out)
  
---------------------------------------------  
-- Test run
mainFunction k = 
  startServer $ \ c ->  
  connectClient c $ \(i,o) -> 
  writeChan i "King Arthur" $
  writeChan i "Holy Grail" $
  k

main = putStrLn $ groom $ mainFunction die initialState


