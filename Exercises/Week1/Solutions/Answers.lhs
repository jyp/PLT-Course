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

\begin{document}
\maketitle

\section{General Remarks}

Function application binds on the left!

Therefore, in general, you {\em can not} use the rule
|a b c = a (b c)|
when reasoning about lambda calculus or haskell expressions!

\section{Lambda Calculus}

%include Lambda.lhs

\section{Why Functional Programming Matters}
%include WhyFP.lhs

\section{Lazy lists}
\begin{code}

nonMultiples p [] = []
nonMultiples p (x:xs) = if x `mod` p == 0 
   then nonMultiples p xs 
   else x : nonMultiples p xs

sieve [] = []
sieve (x:xs) = x : sieve (nonMultiples x xs)

take' 0 _ = []
take' n [] = []
take' n (x:xs) = x : take' (n-1) xs

main = print (take 100 (sieve [2..]))
\end{code}

\end{document}
