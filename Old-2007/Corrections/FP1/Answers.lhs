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
sieve [] = []
sieve (x:xs) = x : sieve [y | y <- xs, mod y x /= 0]

main = print (take 100 (sieve [2..]))
\end{code}

\section{Calculator}

%include ParserLibrary.lhs

%include Calculator.lhs

\section{LISP}

%include Lisp.lhs

\section{Acknowledgements}

Thanks to Staffan Björnesjö and Ann Lillieström for letting us use their ``WhyFP'' material.

\end{document}
