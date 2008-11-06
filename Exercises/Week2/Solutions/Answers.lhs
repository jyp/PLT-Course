% -*- Latex -*-
\documentclass{article}
%include lhs2TeX.fmt
%format `compose` = "\circ "
\usepackage[mathletters]{ucs}
\usepackage[utf8x]{inputenc}
\usepackage{amsmath}
\setlength{\parindent}{0pt}
\setlength{\parskip}{6pt plus 2pt minus 1pt}

\newcommand{\percents}[1]{\protect \marginpar[l]{\bf [#1 points]}}
\newcounter{question}
\newcommand{\answer}[1]{
  \addtocounter{question}{1}
   \textbf{Exercise~\arabic{question}:}  \percents{#1}
 }


\setcounter{secnumdepth}{0}

\title{Functional Programming Exercises, 1}
\author{JP Bernardy and Gustav Munkby}
\begin{document}
\maketitle

\section{Answers to exercises}

\answer{1}
The type is:
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

Rename factor to atom and add
\begin{code}
factor = value (^) @@ atom ## symbol "^" @@ atom
   ||| atom
\end{code}

\answer{1} 
Make the 2nd call a recursive call in each term, factor, expr.

\answer{1}
The parser is right-associative.

\answer{1}
This happens because we do a right-recursive call.
If we try to do left-recursion it will loop!

\answer{0}
See later.

\answer{1}
\begin{code}
($$) :: Parser a -> Parser b -> Parser b
p $$ q = value (\x y->y) @@ p @@ q

white p = many (satisfy isSpace) $$ p
\end{code}

\answer{1}
\begin{code}
symbol tok = white (exactly tok)
\end{code}

Exactly $\rightarrow$ symbol; number $\rightarrow$ white number

\answer{1}

\begin{code}
fails :: Parser a -> Parser ()
fails p = \input -> case p input of
                      [] -> value () input
                      _ -> []
\end{code}
\answer{1}

\begin{code}
some' p = value (:) @@ p @@ many' p
many' p = (value [] ## fails p) ||| some' p
\end{code}

\answer{0}
Questions?

\answer{1}
\begin{code}
atom = white $ value (:) @@ satisfy (`elem` ['a'..'z']) @@ many' alpha

alpha = satisfy (`elem` ['a'..'z']++['0'..'9'])
\end{code}

\answer{1}
\begin{code}
number = white $ value (foldl combine 0) @@ some digit
\end{code}

\answer{3}
(One point per term in the disjunction)
\begin{code}
sexp :: Parser SExp
sexp = symbol "(" $$ value (foldr Cons (Atom "nil")) @@ many' sexp ## symbol ")" 
       ||| value Numb @@ (signed @@ number)
       ||| value Atom @@ atom
\end{code}

\section{Full code}

\subsection{Library}
%include ParserLibrary.lhs

\subsection{Calculator}
%include Calculator.lhs

\subsection{Lisp}
%include Lisp.lhs

\end{document}