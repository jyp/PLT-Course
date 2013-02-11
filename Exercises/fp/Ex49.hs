module Ex49 where

f :: (Either a b,Either c d) ->
     Either (Either (a,c) (b,d)) (Either (a,d) (b,c))
f (Left a,Left c)   = Left (Left (a,c))
f (Left a,Right d)  = Right (Left (a,d))
f (Right b,Left c)  = Right (Right (b,c))
f (Right b,Right d) = Left (Right (b,d))

g :: Either (Either (a,c) (b,d)) (Either (a,d) (b,c)) ->
     (Either a b,Either c d)
g (Left (Left (a,c)))  = (Left a,Left c)
g (Left (Right (b,d))) = (Right b,Right d)
g (Right (Left (a,d))) = (Left a,Right d)
g (Right (Right (b,c))) = (Right b,Left c)
