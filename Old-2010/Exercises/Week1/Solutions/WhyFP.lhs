% -*- Literate-Haskell -*-

\begin{code}
import Prelude (Num(..), Bool(..), Eq(..), Show(..))

or True _ = True
or _ True = True
or _ _ = False

and False _ = False
and _ False = False
and _ _ = True


data ListOf a = Nil | Cons a (ListOf a)
	deriving (Eq,Show)

\end{code}

First attempt at sum:
\begin{spec}
sum Nil            = 0
sum (Cons x list)  = x + sum list
\end{spec}

\begin{code}
sum = reduce add 0

add x y = x + y

reduce f x Nil         = x
reduce f x (Cons a l)  = f a (reduce f x l)

product = reduce multiply 1
multiply x y = x * y

anyTrue = reduce or False
allTrue = reduce and True

append a b = reduce Cons b a

doubleall = reduce (Cons . (2 *)) Nil

doubleall' = reduce doubleandcons' Nil
	where doubleandcons' num list = Cons (2 * num) list

doubleall'' = map (2*)

(f . g) h = f (g h)	

doubleandcons = fandcons' double
	where 
		double n = 2 * n
		fandcons' f el list = Cons (f el) list		
                fandcons f = Cons . f



map f = reduce (Cons . f) Nil


summatrix = sum . map sum


\end{code}


