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


\answer{1}
the type is:
\begin{code}
type Parser a = String -> [(a,String)]
\end{code}

This type represents a tranformation from input (to be parsed) to list of all possible
results paired with the remaining of the input.

\answer{1}

These operations depend on the representation:
\begin{code}
value, satisfy, exactly, (|||), (@@), parse, (digit)
\end{code}

These don't:
\begin{code}
(##), many, some
\end{code}


\answer{1}
\begin{code}
digit = value digitval @@ satisfy isDigit
\end{code}

\answer{1}
The parser is right-associative.


\answer{1}
This happens because we do a right-recursive call.
If we try to do left-recursion it will loop!

\answer{1}



\end{document}