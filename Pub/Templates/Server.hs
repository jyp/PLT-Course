import Control.Concurrent
import Control.Concurrent.Chan

-- For simplicity the queries and replies we will just be strings.
type Reply = String
type Request = String

-- Each connection to a client is implemented by a pair of channels:
-- one for queries and one for replies.
data Connection = ...


------------------------------------------
-- Server code:

handleClient :: Chan Request -> Chan Reply -> IO ()
handleClient input output = do
  -- we can do anything we want here, but we keep it simple for the
  -- purpose of the example.
  return ()

server :: Chan Connection -> IO ()
server c = do
  
  -- wait for new connections and spawn client handlers.
  -- then loop...
  server c

  
-------------------------------------------
-- Startup code 

startServer :: IO (Chan Connection)
startServer = ...

-- connect a new client, given access to the server.
connectClient :: Chan Connection -> IO Connection
connectClient c = ...

-------------------------------------
-- Test run

-- main = do
--   s <- startServer
--   (i,o) <- connectClient s
--  writeChan ...

-- Exercise: start two clients concurrently.



