import Control.Concurrent
ones = do
  putStrLn "1"
  ones

twos = do
  putStrLn "2"
  twos

main = do
  forkIO twos -- create a new process
  ones
