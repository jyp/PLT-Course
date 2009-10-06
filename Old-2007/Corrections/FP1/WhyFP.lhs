% -*- Literate-Haskell -*-

\begin{code}
import Prelude hiding (map, sum, repeat, zip)

data ListOf a = Nil | Cons a (ListOf a)
	deriving (Eq,Show)

infixr 5 `Cons`

\end{code}
convert between Haskell native lists and our list:

\begin{code}
convert :: [a] -> ListOf a
convert []      = Nil
convert (x:xs)  = Cons x (convert xs)


\end{code}

Ugly sum:
\begin{spec}
sum Nil            = 0
sum (Cons x list)  = x + sum list
\end{spec}


\begin{code}
sum = reduce (+) 0

reduce f x Nil         = x
reduce f x (Cons a l)  = f a (reduce f x l)

product = reduce (*) 1

anyTrue = reduce (||) False
allTrue = reduce (&&) True

append a b = reduce Cons b a

doubleall = reduce (Cons . (2 *)) Nil

doubleall' = reduce doubleandcons' Nil
	where doubleandcons' num list = Cons (2 * num) list

doubleall'' = map (2*)
	
doubleandcons = fandcons' double
	where 
		double n = 2 * n
		fandcons' f el list = Cons (f el) list		
                fandcons f = Cons . f



map f = reduce (Cons . f) Nil


summatrix = sum . map sum

data Tree x = Node x (ListOf (Tree x)) 
	deriving Show


redtree f g a (Node label subtrees) = f label (redtree' f g a subtrees)

redtree' f g a (Cons subtree rest) = g (redtree f g a subtree) (redtree' f g a rest)
redtree' f g a Nil = a

sumtree = redtree (+) (+) 0

labels = redtree Cons append Nil

maptree f = redtree (Node . f) Cons Nil

\end{code}
Newton-Raphson Square Roots
\begin{code}

next n x = (x + n/x) / 2

repeat f a = a `Cons` (repeat f (f a))

abs x | x < 0 = -x
abs x | x >= 0 = x

within eps (a `Cons`(b `Cons` rest))
	| abs (a-b) <= eps = b
	| otherwise = within eps (b`Cons` rest)

squareroot a0 eps n = within eps (repeat (next n) a0)

relative eps (a`Cons` (b`Cons` rest)) 
	| abs(a-b) <= eps*(abs b) = b
        | otherwise = relative eps (b`Cons`rest)
    
relativesqrt a0 eps n = relative eps (repeat (next n) a0)

\end{code}

Numerical Differentiation

\begin{code}

easydiff f x h = (f(x+h)-f x) / h

differentiate h0 f x = map (easydiff f x) (repeat halve h0)
	where halve x = x/2
	
derivative h0 f x eps = within eps (differentiate h0 f x)

elimerror n (a `Cons` (b `Cons` rest)) = ((b*(2^n)-a)/(2^n-1)) `Cons` (elimerror n (b `Cons` rest))

order (a `Cons` (b `Cons` (c `Cons` rest))) = round(log( (a-c)/(b-c) - 1 ))

improve s = elimerror (order s) s

differentiate' h0 f x eps = within eps (improve (differentiate h0 f x))

differentiate'' h0 f x eps = within eps (improve (improve (improve (differentiate h0 f x))))

super s = map second (repeat improve s)

second (a `Cons` b `Cons` rest) = b

superdiff h0 f x eps = within eps (super (differentiate h0 f x))

\end{code}

Numerical Integration

\begin{code}


easyintegrate f a b = (f a + f b)*(b-a)/2

zip (Cons a s) (Cons b t) = Cons (a,b) (zip s t)
zip Nil _ = Nil
zip _ Nil = Nil

integrate f a b =  (easyintegrate f a b) `Cons` 
                   (map addpair (zip (integrate f a mid) (integrate f mid b)))
	where mid = (a+b)/2

addpair (a,b) = a+b

integrate' f a b = integ f a b (f a) (f b)

integ f a b fa fb =  ((fa+fb)*(b-a)/2) `Cons` 
                     (map addpair (zip (integ f a m fa fm) (integ f m b fm fb)))
	where  m = (a+b)/2
               fm = f m

integrate''   f a b eps 	= within eps (integrate' f a b) 
integrate'''  f a b eps 	= relative eps (integrate' f a b)

test = super (integrate sin 0 4)
test2 = improve (integrate f 0 1)
    where f x = 1/(1+x*x)

\end{code}


