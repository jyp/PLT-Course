import Control.Concurrent
import Control.Concurrent.Chan

data Query = Call Int (Chan Int)

serverFunction n = product [1..n]

server :: Chan Query -> IO ()

createServer :: IO (Chan Query)

remoteCall :: Chan Query -> Int -> IO Int

-- main = do
--   c <- createServer
--   remoteCall c 5



