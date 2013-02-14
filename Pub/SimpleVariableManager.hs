import Control.Concurrent
import Control.Concurrent.Chan

data Queries = Get (Chan Int) | Set Int

manager :: Int -> Chan Queries -> IO ()
manager value c = do
  q <- readChan c
  case q of
    Set newValue -> manager newValue c
    Get returnChannel -> do writeChan returnChannel value
                            manager value c

-- writeChan c (Get returnChannel)

-- writeChan c (Set v)

main = do
  c <- newChan
  forkIO (manager 0 c)
  return c



