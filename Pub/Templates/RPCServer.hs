module RPCS where

import Control.Concurrent

data Query = Call Int (Chan Int)

-- Idea: instead of computing the function locally, have another
-- process running it (in reality perhaps on another, faster machine,
-- or one that has data that we don't want to transfer to the client)
serverFunction n = product [1..n]

-- API
-- createServer :: IO (Chan Query)
-- remoteCall :: Chan Query -> Int -> IO Int

-- Example usage:
-- main = do
--   c <- createServer
--   remoteCall c 5

-- Implementation:
-- server :: Chan Query -> IO ()




