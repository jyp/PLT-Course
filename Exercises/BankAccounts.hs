import Control.Concurrent
import Control.Concurrent.Chan

data AccReq = Deposit Int (Chan AccResp)
            | Withdraw Int (Chan AccResp)
            | Poll (Chan AccResp)

instance Show AccReq where
  show (Deposit n _) = "depositing " ++ show n
  show (Withdraw n _) = "withdrawing " ++ show n
  show (Poll _) = "polled"

data AccResp = AccOk | AccFail | AccSt Int deriving Show

type Account = Chan AccReq
type Amount = Int

account :: Account -> Amount -> IO ()
account c s = do
  req <- readChan c
  putStrLn $ show req
  case req of
    Deposit n c' -> do
      writeChan c' AccOk
      account c (s + n)
    Withdraw n c' -> if s >= n
                     then do
                       writeChan c' AccOk
                       account c (s - n)
                     else do
                       writeChan c' AccFail
                       account c s
    Poll c' -> do
      writeChan c' $ AccSt s
      account c s

openAccount :: Amount -> IO Account
openAccount n = do
  c <- newChan
  forkIO $ account c n
  return c

pollAccount :: Account -> IO Int
pollAccount c = do
  c' <- newChan
  writeChan c $ Poll c'
  (AccSt s) <- readChan c'
  return s

data TrReq = Move Account Account Int (Chan TrResp)

instance Show TrReq where
  show (Move _ _ n _) = "transferring " ++ show n

data TrResp = TrOk | TrFunds | TrFail deriving Show

type Transaction = Chan TrReq

transaction :: Transaction -> IO ()
transaction c = do
  req <- readChan c
  putStrLn $ show req
  case req of
    Move a1 a2 n c' -> do
      a1r <- newChan
      writeChan a1 $ Withdraw n a1r
      w <- readChan a1r
      putStrLn $ show w
      case w of
        AccOk -> do
          a2r <- newChan
          writeChan a2 $ Deposit n a2r
          d <- readChan a2r
          putStrLn $ show d
          case d of
            AccOk -> do
              writeChan c' TrOk
            AccFail -> do
              writeChan a1 $ Deposit n a1r
        AccFail -> do
          writeChan c' TrFunds
  transaction c

main = do
  -- init
  t <- newChan
  t' <- newChan
  forkIO $ transaction t
  a1 <- openAccount 100
  a2 <- openAccount 200
  -- pre-check
  a1s <- pollAccount a1
  a2s <- pollAccount a2
  putStrLn $ "Account 1: " ++ show a1s
  putStrLn $ "Account 2: " ++ show a2s
  -- action
  writeChan t $ Move a1 a2 50 t'
  resp <- readChan t'
  putStrLn $ "Transaction: " ++ show resp
  -- post-check
  a1s <- pollAccount a1
  a2s <- pollAccount a2
  putStrLn $ "Account 1: " ++ show a1s
  putStrLn $ "Account 2: " ++ show a2s
  -- action
  writeChan t $ Move a1 a2 70 t'
  resp <- readChan t'
  putStrLn $ "Transaction: " ++ show resp
  -- post-check
  a1s <- pollAccount a1
  a2s <- pollAccount a2
  putStrLn $ "Account 1: " ++ show a1s
  putStrLn $ "Account 2: " ++ show a2s
