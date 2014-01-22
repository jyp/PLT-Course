-- Can we explain the meaning of a function call using the substitution model?



fib n = if n <= 1 then n else fib (n-1) + fib (n-2)
