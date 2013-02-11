
import Prelude hiding (map)

-- Closures of @Integer -> Integer@
data Closure
    = ReplaceLambda Integer Integer
    -- ^ a and b from @\ x -> if x == a then b else x@
    | MomentLambda Integer
    -- ^ n from @\ x -> x ^ n@

applyCl :: Closure -> Integer -> Integer
applyCl (ReplaceLambda a b) x = if x == a then b else x
applyCl (MomentLambda n) x = x ^ n

map :: Closure -> [Integer] -> [Integer]
map c []     = []
map c (x:xs) = applyCl c x : map c xs

replace a b xs = map (ReplaceLambda a b) xs
moment n xs = sum (map (MomentLambda n) xs)


