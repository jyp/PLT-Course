module RuntimeSystem where

type ChannelIdentifier = Int 
type Chan = ChannelIdentifier

type Message = String

instance Show (a -> b) where
    show f = "<function>"

data ChanelState = ChanelState {
      chanelMessages :: [Message], -- messages pending
      chanelListeners :: [Message -> Process] -- processes blocked on the chanel
    } deriving Show
-- INVARIANT: if the system is blocked, then either list is empty

data System = System {
      readyProcesses :: [Process],
      channels :: [ChanelState]
    } deriving Show

-- | Type of a process. (Here, only a transformation of the system)
type Process = System -> System

-- | Initial state: no channel, no process.
initialState = System [] []

------------------------------------------------
-- Scheduler

scheduler :: System -> System
scheduler = simpleScheduler . unblockSystem

-- Trivial scheduler: run the 1st ready process in the list.
simpleScheduler (System []     chans) = System [] chans     -- no ready to run process: system blocked
simpleScheduler (System (p:ps) chans) = p (System ps chans) -- run the 1st ready process

-- | Wake up listeners on a channel, as much as possible. 
-- Return new channel state, and woken up processes.
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

fork :: (Process -> Process) -> Process -> (System -> System)
fork p k s = scheduler $ addProcess (p die) $ addProcess k $ s

-- | Write a message to a channel, and continue with 'k'
writeChan :: Chan -> String -> Process -> Process
writeChan c msg k s = scheduler $ 
                      updateChan c (addMessage msg) $
                      addProcess k $ s


-- | Read a message from a channel, and continue with 'k'
-- here the continuation depends on the result
readChan :: Chan -> (Message -> Process) -> Process
readChan c k s = scheduler $ updateChan c (addListener k) $ s

-- | Create a new channel and continue with 'k'
-- (again there is a dependency)
newChan :: (Chan -> Process) -> Process
newChan k (System ps chs) = scheduler $ addProcess (k ch) $ (System ps (chs ++ [ChanelState [] []]))
   where ch = length chs

die :: Process
    -- System -> System
die = scheduler -- just go back to the scheduler to see if there is more work to do.


-- helpers

-- | Add a messeage to a channel
addMessage m (ChanelState ms ws) = ChanelState (ms++[m]) ws

-- | Add a listener to a channel
addListener k (ChanelState ms ks) = ChanelState ms (k:ks)

-- | Update a given channel in the system
updateChan :: Chan -> (ChanelState -> ChanelState) -> System -> System
updateChan c f (System ps chs) = System ps (left++f ch:right) 
    where (left,ch:right) = splitAt c chs

-- | Add a process
addProcess p (System ps chs) = System (p:ps) chs



