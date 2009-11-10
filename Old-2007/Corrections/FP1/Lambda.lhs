% -*- Latex -*-
% Literate-Haskell

\begin{enumerate}
\item{Beta-conversion}

\begin{code}
let  t = twice
     i = inc
\end{code}

By using $\beta$ reduction we find that, 
\begin{code}
t a b
= (\f -> \x -> f (f (x))) a b 
= (\x -> a (a (x))) b
=  a (a (b))
\end{code}
We will use this rule many times in the following; always applying it to the leftmost |t|.

\begin{enumerate}
\item
\begin{code}
twice inc 0
(\f -> \x -> f(f x)) inc 0 
(\x -> f (f x))[f := inc] 0
(\x -> inc (inc x)) 0
(inc (inc x))[x := 0]
inc (inc 0)
(\x-> x + 1) (inc 0)
(x+1)[x:=inc 0]
inc 0 + 1
(\x -> x + 1) 0 + 1
(x + 1)[x := 0] + 1
(0 + 1) + 1
2
\end{code}
or using the above rule:
\begin{code}
t i 0
i (i 0)
2
\end{code}

\item
\begin{code}
t t i 0
t (t i) 0
t i (t i 0)
i (i (t i 0)
i (i (i (i 0)))
4
\end{code}


\item
\begin{code}
t (t t) i 0
t t ((t t) i) 0
t (t ((t t) i)) 0
t ((t t) i) (t ((t t) i) 0)
(t t) i ((t t) i (t ((t t) i) 0))
t (t i) ((t t) i (t ((t t) i) 0))
t i (t i ((t t) i (t ((t t) i) 0)))
i (i (t i ((t t) i (t ((t t) i) 0))))
i (i (i (i ((t t) i (t ((t t) i) 0)))))
i (i (i (i (t (t i)(t ((t t) i) 0)))))
i (i (i (i (t i (t i (t ((t t) i) 0))))))
i (i (i (i (i (i (t i (t ((t t) i) 0)))))))
i (i (i (i (i (i (i (i (t ((t t) i) 0))))))))
i (i (i (i (i (i (i (i ((t t) i ((t t) i 0)))))))))
i (i (i (i (i (i (i (i (t (t i) ((t t) i 0)))))))))
i (i (i (i (i (i (i (i (t i (t i ((t t) i 0))))))))))
i (i (i (i (i (i (i (i (i (i (t i ((t t) i 0)))))))))))
i (i (i (i (i (i (i (i (i (i (i (i ((t t) i 0))))))))))))
i (i (i (i (i (i (i (i (i (i (i (i (t (t i) 0))))))))))))
i (i (i (i (i (i (i (i (i (i (i (i (t i (t i 0)))))))))))))
i (i (i (i (i (i (i (i (i (i (i (i (i (i (t i 0))))))))))))))
i (i (i (i (i (i (i (i (i (i (i (i (i (i (i (i 0)))))))))))))))
16
\end{code}

\item
\begin{code}
t t t i 0
t (t t) i 0 -- applying the above
16 
\end{code}

\item
\begin{code}
(\x-> x) (\x-> x)
(\x-> x)


\end{code}

\item
\begin{code}
(\x-> x x) (\x-> x x)
(\x-> x x) (\x-> x x)       

\end{code}
(reduces to the same thing)

\item{Church numerals}
\begin{code}
inc = \x -> x + 1

twice = \f -> \x -> f (f x)

zero = \f -> \x -> x

one = \f -> \x -> f x

unChurch f = f inc 0

church 0 = zero
church n = \f -> \x -> f (church (n-1) f x)

suc n = \f -> \x -> f (n f x)
\end{code}
or
\begin{code}
suc n = \f -> \x -> n f (f x)

add n m = \f -> \x -> n f (m f x)

mul n m = \f -> \x -> n (m f) x
\end{code}

\end{enumerate}

\item{LISP}
\begin{code}
cons x y f = f x y

car c = c (\x _ -> x)
cdr c = c (\_ x -> x)
\end{code}

\end{enumerate}

The above calculation of |twice (twice twice) inc 0| was somewhat
tiresome... Can you find a very quick way to do it using church numerals? 

Hints: 
If $c_n$ is the nth church numeral, what is $n$ in $c_n = twice$?
What is $x$ equal to in $c_x = c_m (c_n)$? 

