% -*- Latex -*-
\documentclass{article}
%include lhs2TeX.fmt
%format `compose` = "\circ "
\usepackage[mathletters]{ucs}
\usepackage[utf8x]{inputenc}
\usepackage{amsmath}
\setlength{\parindent}{0pt}
\setlength{\parskip}{6pt plus 2pt minus 1pt}


\setcounter{secnumdepth}{0}

\title{Functional Programming Exercises, 1}
\author{JP Bernardy and Gustav Munkby}
\begin{document}
\maketitle

\section{General Remarks}

\begin{itemize}
\item
A \emph{redex} is an expression of the form:
|(\x -> ...) e|. Substitute |x| by |e| in the ellipsis
to apply the $\beta$ rule.

\item
Function application binds on the left!

Therefore, in general, you {\em can not} use the rule
|a b c = a (b c)|
when reasoning about lambda calculus or haskell expressions!

\item
In particular, in |a (\x -> ...) c|, |(\x -> ...) c| is not a redex.
The redex is always on the left of a series of applications.
\end{itemize}



\section{Lambda Calculus}

%include Lambda.lhs

\section{Why Functional Programming Matters}
%include WhyFP.lhs

\section{Lazy lists}
\begin{code}

import Prelude (Eq(..), Num(..), mod, print)

nonMultiples p [] = []
nonMultiples p (x:xs) = if x `mod` p == 0 
   then nonMultiples p xs 
   else x : nonMultiples p xs

sieve [] = []
sieve (x:xs) = x : sieve (nonMultiples x xs)

take 0 _ = []
take n [] = []
take n (x:xs) = x : take (n-1) xs

main = print (take 100 (sieve [2..]))
\end{code}

\end{document}
