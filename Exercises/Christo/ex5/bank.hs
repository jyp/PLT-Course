import Control.Concurrent

data Answer = OK | NotEnoughMoney | BalanceResponse Integer
	deriving Show
data Query = Deposit (Chan Answer) Integer
           | Withdraw (Chan Answer) Integer
           | Balance (Chan Answer)


account = do
	chan <- newChan
	forkIO $ go chan 0
	return chan
	where go chan state = do
		m <- readChan chan
		case m of
			Deposit ans x -> do
				writeChan ans OK
				go chan (state+x)
			Withdraw ans x | x <= state -> do
				writeChan ans OK
				go chan (state-x)
			Withdraw ans _ -> do
				writeChan ans NotEnoughMoney
				go chan state
			Balance ans -> do
				writeChan ans (BalanceResponse state)
				go chan state


deposit chan ans x = do
	writeChan chan (Deposit ans x)
	readChan ans
withdraw chan ans x = do
	writeChan chan (Withdraw ans x)
	readChan ans
balance chan ans = do
	writeChan chan (Balance ans)
	readChan ans

main = do
	bank <- account
	ans <- newChan
	print =<< balance bank ans
	print =<< deposit bank ans 100
	print =<< withdraw bank ans 10
	print =<< withdraw bank ans 200
	print =<< balance bank ans

