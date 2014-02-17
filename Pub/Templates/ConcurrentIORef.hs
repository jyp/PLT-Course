import Control.Concurrent
import Data.IORef

-- | Increment the given reference 
-- increment :: IORef Int -> IO ()
-- hint: use readIORef and writeIORef
increment 0 v = return ()
increment n v = do
  x <- readIORef v
  writeIORef v (x+1)
  increment (n-1) v

-- Fork two processes accessing the same variable
  -- hint: use newIORef

