import Control.Concurrent
import Control.Concurrent.Chan

type Variable a = Chan (Command a)

-- handler :: Variable a -> a -> IO ()

-- newVariable :: a -> IO (Variable a)

-- get :: Variable a -> IO a

-- set :: Variable a -> a -> IO ()

-- main = do
--   v <- newVariable "initial value"
--   set v "new value"
--   get v >>= putStrLn
