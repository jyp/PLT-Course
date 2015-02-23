module Server where

-- import Control.Concurrent
-- import Control.Concurrent.Chan

-- For simplicity the queries and replies we will just be strings.
type Reply = String
type Request = String

-- Each connection to a client is implemented by a pair of channels:
-- one for queries and one for replies.
data Connection = Connect (Chan Request) (Chan Reply)

type Effect = ()
type CP x = (x -> Effect) -> Effect

type Chan x = () -- TODO
writeChan :: Chan x -> x -> CP ()
writeChan = undefined
readChan :: Chan x -> CP x
readChan = undefined
newChan :: CP (Chan x)
newChan = undefined
forkCP :: CP () -> CP ()
forkCP = undefined


------------------------------------------
-- Server code:

handleClient :: Chan Request -> Chan Reply -> CP ()
handleClient input output k = 
  writeChan output "Username:" ( \_ ->
  readChan input (\username ->
  writeChan output "Password:" (\_ ->
  readChan input (\pass ->
  (case username == "bernardy" && pass == "123" of
    True -> writeChan output "Welcome to the server"
    False -> writeChan output "Password or username incorrect") (\_ ->
  k ())))))

server :: Chan Connection -> (() -> Effect) -> Effect
server c k =
  readChan c $ \(Connect input output) ->
  -- wait for new connections and spawn client handlers.
  forkCP (handleClient input output) $ \_ ->
  -- then loop...
  server c k

  
-- -------------------------------------------
-- -- Startup code 

startServer :: (Chan Connection -> Effect) -> Effect
startServer k =
  newChan $ \c ->
  forkCP (server c) $ \_ ->
  k c

-- -- connect a new client, given access to the server.
connectClient :: Chan Connection -> CP Connection
connectClient c k =
  newChan $ \inp ->
  newChan $ \out ->
  writeChan c (Connect inp out) $ \_ ->
  k (Connect inp out)

-------------------------------------
-- Test run

-- main = do
--   s <- startServer
--   (i,o) <- connectClient s
--  writeChan ...

-- Exercise: start two clients concurrently.



