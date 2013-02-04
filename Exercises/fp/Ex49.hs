module Ex49 where

f :: (Either a b,Either c d) -> Either (a,c) (b,d)
f (Left a,Left c) = Left (a,c)
f (Left a,Right d) = undefined
f (Right b,Left c) = undefined
f (Right b,Right d) = Right (b,d)

g :: Either (a,c) (b,d) -> (Either a b,Either c d)
g (Left (a,c)) = (Left a,Left c)
g (Right (b,d)) = (Right b,Right d)

