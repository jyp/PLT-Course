module RuntimeSystem where

type CP x = (x -> Effect) -> Effect
type Effect = Process

type ChannelIdentifier = Int
type Chan = ChannelIdentifier

type Message = String

instance Show (a -> b) where
    show _ = "<function>"

data ChannelState = ChannelState 
                    { channelMessages :: [Message] --pending messages
                    , channelListeners :: [Message -> Process] -- blocked processes
                    }
-- The state of a channel will be a list of messages and a list of listeners.
-- INVARIANT: if the system is blocked, then either list is empty

data System = System { processes :: [Process]
                     , channels :: [ChannelState]
                     }
-- The state of the system will be a list of ready processes and a
-- list of ready channels.

type Process = System -> System

-- | Initial state: no channel, no process.
initialState :: System
initialState = System [] []

writeChan :: Chan -> String -> (() -> Process) -> System -> System
writeChan c msg k s = scheduler $
                      updateChan c (addMessage msg) $
                      addProcess (k ()) $
                      s

readChan :: Chan -> (Message -> Process) -> System -> System
readChan c k s = scheduler $
                 updateChan c (addListener k) $
                 s

newChan :: (Chan -> Process) -> System -> System
newChan k (System ms chs) =
  scheduler $
  addProcess (k (length chs)) $
  (System ms (chs++[ChannelState [] []]))

forkCP :: ((() -> Process) -> Process) -> (() -> Process) -> System -> System
forkCP spawned k s = scheduler $
                     addProcess (spawned $ \() -> terminate) $
                     addProcess (k ()) $
                     s

terminate :: System -> System
terminate = scheduler

------------------------------------------------
-- Scheduler
scheduler :: System -> System
scheduler = simpleScheduler . unblockSystem

-- Trivial scheduler: run the 1st ready process in the list.
simpleScheduler :: System -> System
simpleScheduler (System []     chans) = System [] chans     -- no ready to run process: system blocked
simpleScheduler (System (p:ps) chans) = p (System ps chans) -- run the 1st ready process

-- | Wake up listeners on a channel, as much as possible. 
-- Return new channel state, and woken up processes.
unblockListersOnAChannel :: ChannelState -> (ChannelState,[Process])
unblockListersOnAChannel (ChannelState [] ws) = (ChannelState [] ws,[])
unblockListersOnAChannel (ChannelState ms []) = (ChannelState ms [],[])
unblockListersOnAChannel (ChannelState (m:ms) (w:ws)) = (ch,w m:ps)
   where (ch,ps) = unblockListersOnAChannel (ChannelState ms ws)


unblockSystem :: System -> System
unblockSystem (System ps chs) = (System (ps'++ps) chs')
    where (chs',ps') = unblockChannels chs

unblockChannels :: [ChannelState] -> ([ChannelState],[Process])
unblockChannels chs = (chs',concat ps)
    where (chs',ps) = unzip $ map unblockListersOnAChannel chs


--------------------------
-- helpers

-- | Add a messeage to a channel
addMessage :: Message -> ChannelState -> ChannelState
addMessage m (ChannelState ms ws) = ChannelState (ms++[m]) ws

-- | Update a given channel in the system
updateChan :: Chan -> (ChannelState -> ChannelState) -> System -> System
updateChan c f (System ps chs) = System ps (left++f ch:right)
    where (left,ch:right) = splitAt c chs

-- | Add a listener to a channel
addListener k (ChannelState ms ks) = ChannelState ms (k:ks)

-- | Add a process
addProcess p (System ps chs) = System (p:ps) chs


