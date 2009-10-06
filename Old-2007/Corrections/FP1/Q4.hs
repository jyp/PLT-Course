

-- input list does not contain elements multiple of numbers smaller than p
sieve (p:rest) = p:sieve (filter (not . multiple p) rest)
    where multiple p x = x `mod` p == 0

-- sieve (p:rest) = p : sieve [n | n <- rest, n mod p /= 0] (http://en.wikipedia.org/wiki/Miranda_%28programming_language%29)

primes = sieve [2..]

main = print $ take 100 $ primes
