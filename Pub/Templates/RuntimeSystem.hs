module RuntimeSystem where

type ChannelIdentifier = Int 
type Chan = ChannelIdentifier

type Message = String

instance Show (a -> b) where
    show f = "<function>"

data ChannelState = ...
-- The state of a channel will be a list of messages and a list of listeners.
-- INVARIANT: if the system is blocked, then either list is empty

data System = ...
-- The state of the system will be a list of ready processes and a
-- list of ready channels.

-- | Type of a process. (Here, only a transformation of the system)
type Process = System -> System

-- | Initial state: no channel, no process.
initialState = undefined

------------------------------------------------
-- Scheduler

scheduler :: System -> System
scheduler = trivialScheduler . unblockSystem

-- Trivial scheduler: run the 1st ready process


-- | Wake up listeners on a channel, as much as possible. 
-- Return new channel state, and woken up processes.
unblockListersOnAChannel :: ChanelState -> (ChanelState,[Process])


unblockSystem :: System -> System

unblockChannels :: [ChanelState] -> ([ChanelState],[Process])


----------------------
-- System calls

forkIO :: MyIO () -> MyIO ()
forkIO p k s = undefined

-- | Write a message to a channel, and continue with 'k'
writeChan :: Chan -> String -> MyIO ()
writeChan c msg k s = undefined


-- | Read a message from a channel, and continue with 'k'
-- here the continuation depends on the result
readChan :: Chan -> MyIO Message
readChan c k s = undefined

-- | Create a new channel and continue with 'k'
-- (again there is a dependency)
newChan :: MyIO Chan
newChan k (System ps chs) = undefined

die :: () -> Process
die _ = scheduler
        -- just go back to the scheduler to see if there is more work to do.


-- helpers

-- | Add a messeage to a channel
addMessage m (ChanelState ms ws) = undefined

-- | Add a listener to a channel
addListener k (ChanelState ms ks) = undefined

-- | Update a given channel in the system
updateChan :: Chan -> (ChanelState -> ChanelState) -> System -> System
updateChan c f (System ps chs) = undefined
    where (left,ch:right) = splitAt c chs

-- | Add a process
addProcess p (System ps chs) = undefined



