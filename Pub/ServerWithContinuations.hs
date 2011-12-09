import Text.Groom

type Cha = Int
type Message = String

type Chan = Int

instance Show (a -> b) where
    show f = "<function>"

data ChanelState = ChanelState {
      chanelMessages :: [Message],
      chanelListeners :: [Message -> Process]
    } deriving Show

data System = System {
      readyProcesses :: [Process],
      channels :: [ChanelState]
    } deriving Show

type Process = System -> System

initialState = System [] []

------------------------------------------------
-- Scheduler

scheduler :: System -> System
scheduler = simpleScheduler . unblockSystem

simpleScheduler :: System -> System
simpleScheduler (System []     chans) = System [] chans     -- no ready to run process: system blocked
simpleScheduler (System (p:ps) chans) = p (System ps chans) -- run the 1st ready process

unblockListersOnAChannel :: ChanelState -> (ChanelState,[Process])
unblockListersOnAChannel (ChanelState [] ws) = (ChanelState [] ws,[])
unblockListersOnAChannel (ChanelState ms []) = (ChanelState ms [],[])
unblockListersOnAChannel (ChanelState (m:ms) (w:ws)) = (ch,w m:ps)
   where (ch,ps) = unblockListersOnAChannel (ChanelState ms ws)


unblockSystem :: System -> System
unblockSystem (System ps chs) = (System (ps'++ps) chs')
    where (chs',ps') = unblockChannels chs

unblockChannels :: [ChanelState] -> ([ChanelState],[Process])
unblockChannels chs = (chs',concat ps)
    where (chs',ps) = unzip $ map unblockListersOnAChannel chs


----------------------
-- System calls

fork :: Process -> Process -> Process
fork p k s = scheduler $ addProcess p $ addProcess k $ s

writeChan :: Chan -> String -> Process -> Process
writeChan c msg k s = scheduler $ updateChan c (addMessage msg) $ addProcess k $ s
    
-- here the continuation depends on the result
readChan :: Chan -> (Message -> Process) -> Process
readChan c k s = scheduler $ updateChan c (addListener k) $ s

newChan :: (Chan -> Process) -> Process
newChan k (System ps chs) = scheduler $ addProcess (k ch) $ (System ps (chs ++ [ChanelState [] []]))
   where ch = length chs
         
  
    


die :: Process
die = scheduler -- just go back to the scheduler to see if there is more work to do.


-- helpers

addMessage m (ChanelState ms ws) = ChanelState (m:ms) ws
addListener w (ChanelState ms ws) = ChanelState ms (w:ws)

updateChan :: Chan -> (ChanelState -> ChanelState) -> System -> System
updateChan c f (System ps chs) = System ps (left++f ch:right) 
    where (left,ch:right) = splitAt c chs
addProcess p (System ps chs) = System (p:ps) chs



data Connect = Connect Chan Chan

------------------------------------------
-- Server code:

handleClient :: Chan -> Chan -> Process -> Process
handleClient input output k = 
  writeChan output "What is your name?" $
  readChan input $ \name ->
  writeChan output "What is your quest?" $
  readChan input $ \pass -> 
  (case name /= "King Arthur" || pass /= "Holy Grail"  of
     False -> writeChan output "Incorrect login or password" 
     True  -> writeChan output "You shall pass!") $
  k
  

server c k = 
  readChan c $ \chs ->
  let [d1,d2] = chs
      input  = read [d1]
      output = read [d2]
  in fork (handleClient input output die) $
     server c k
    

startServer k = 
  newChan $ \c ->
  fork (server c die) $
  k c

startClient s k = 
  newChan $ \inp ->
  newChan $ \out ->
  writeChan s (show inp ++ show out) $
  k
  

startAll k = 
  startServer $ \ c ->  
  startClient c $ k

{-
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

-}