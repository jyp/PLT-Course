% -*- Latex -*-
% Literate-Haskell

\begin{enumerate}
\item{Beta-conversion}

\begin{enumerate}
\item
\begin{code}
twice inc 0
(\f -> \x -> f (f x)) (1 +) 0
(\x -> (1 +) ((1 +) x)) 0
(1 +) ((1 +) 0)
\end{code}

\item
\begin{code}
(\f -> \x -> f (f x)) (\f -> \x -> f (f x)) (1 +) 0
(\x -> (\f -> \x -> f (f x)) ((\f -> \x -> f (f x)) x)) (1 +) 0
(\f -> \x -> f (f x)) ((\f -> \x -> f (f x)) (1 +)) 0
(\x -> (\f -> \x -> f (f x)) (1 +) ((\f -> \x -> f (f x)) (1 +) x)) 0
(\f -> \x -> f (f x)) (1 +) ((\f -> \x -> f (f x)) (1 +) 0)
(\x -> (1 +) ((1 +) x)) ((\f -> \x -> f (f x)) (1 +) 0)
(1 +) ((1 +) ((\f -> \x -> f (f x)) (1 +) 0))
(1 +) ((1 +) ((\x -> (1 +) ((1 +) x)) 0))
(1 +) ((1 +) ((1 +) ((1 +) 0)))
\end{code}

\item
\begin{code}
(\x ->  x) (\x ->  x)
(\x ->  x)
\end{code}

\item
\begin{code}
(\x-> x x) (\x-> x x)
(\x-> x x) (\x-> x x)       
\end{code}
(reduces to the same thing)
\end{enumerate}

\item{Church numerals}
\begin{enumerate}
\begin{code}

zero = \f -> \x -> x

one = \f -> \x -> f x

unChurch f = f inc 0
  where inc = \x -> x + 1

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

Extra remark:

What is $x$ equal to in $c_x = c_m (c_n)$? 


