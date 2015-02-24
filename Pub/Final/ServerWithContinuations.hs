module Server where

import RuntimeSystem

-- For simplicity the queries and replies we will just be strings.
type Reply = String
type Request = String

-- Each connection to a client is implemented by a pair of channels:
-- one for queries and one for replies.
data Connection = Connect (Chan) (Chan)



------------------------------------------
-- Server code:

handleClient :: Chan -> Chan -> CP ()
handleClient input output k = 
  writeChan output "Username:" ( \_ ->
  readChan input (\username ->
  writeChan output "Password:" (\_ ->
  readChan input (\pass ->
  (case username == "bernardy" && pass == "123" of
    True -> writeChan output "Welcome to the server"
    False -> writeChan output "Password or username incorrect") (\_ ->
  k ())))))

server :: Chan -> (() -> Effect) -> Effect
server c k =
  readChan c $ \[d1,d2] ->
  let input = read [d1]
      output = read [d2]
  -- wait for new connections and spawn client handlers.
  in forkCP (handleClient input output) $ \_ ->
  -- then loop...
  server c k

  
-- -------------------------------------------
-- -- Startup code 

startServer :: (Chan -> Effect) -> Effect
startServer k =
  newChan $ \c ->
  forkCP (server c) $ \_ ->
  k c

-- -- connect a new client, given access to the server.
connectClient :: Chan -> CP Connection
connectClient c k =
  newChan $ \inp ->
  newChan $ \out ->
  writeChan c (show inp ++ show out) $ \_ ->
  k (Connect inp out)

-------------------------------------
-- Test run

-- main = do
--   s <- startServer
--   (i,o) <- connectClient s
--  writeChan ...

-- Exercise: start two clients concurrently.



