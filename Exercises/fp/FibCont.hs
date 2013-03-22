yield :: IO () -> IO ()
yield k = do
  print "do something else!"
  k

fib :: Int -> (Int -> IO ()) -> IO ()
fib 0 k = k 0
fib 1 k = k 1
fib n k = fib (n-1) $ \x1 -> yield $ fib (n-2) $ \x2 -> k $ x1+x2
                          
