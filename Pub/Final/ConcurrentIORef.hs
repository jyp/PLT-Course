import Control.Concurrent
import Data.IORef

increment :: Int -> IORef Int -> IO ()
increment 0 v = return ()
increment n v = do
  x <- readIORef v
  writeIORef v (x+1)
  increment (n-1) v

main = do 
  v <- newIORef 0
  forkIO $ increment 10000 v
  increment 10000 v
  x <- readIORef v
  print x

