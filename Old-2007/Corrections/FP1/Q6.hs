import ParserLibrary
import Calculator2
import Test.QuickCheck
import Monad

data SExp = Numb Int 
          | Atom String
          | Cons SExp SExp
            deriving (Show, Eq)

--sample = foldr1 Cons [Numb i | i <- [1..5]]
sample0 = (Cons (Numb 2) (Atom "nil"))
sample = Cons (Numb 1) (Cons (Numb 2) (Atom "nil"))

-- 1.
stringP p (Numb i) = show i
stringP p (Atom s) = s
stringP p (Cons h (Atom "nil")) = (if p then paren else id) (string h)
stringP p (Cons h t) = (if p then paren else id) (string h ++ " " ++ stringP False t)

string = stringP True

paren x = "(" ++ x ++ ")"



-- 2.
signed = value negate ## symbol "-" ||| value id

sexp :: Parser SExp
sexp = symbol "(" $$ value (foldr Cons (Atom "nil")) @@ many' sexp ## symbol ")" 
       ||| value Numb @@ (signed @@ number)
       ||| value Atom @@ atom

atom = white $ value (:) @@ satisfy (`elem` ['a'..'z']) @@ many' alpha

alpha = satisfy (`elem` ['a'..'z']++['0'..'9'])


{-
outerW, innerW :: Parser SExp
outerW = elementW
 ||| value Cons ## exactlyW "(" @@
                       outerW @@ innerW
                ## exactlyW ")" ## epsilonW

innerW = value (Atom "nil") ## exactly ""
     ||| value Cons @@ outerW @@ innerW

elementW = numberW
       ||| atomW
-}

----------

arbitraryChar = elements (['a'..'z']++['0'..'9'])
arbitraryString = oneof [return [], liftM2 (:) arbitraryChar arbitraryString ]

instance Arbitrary SExp where
  arbitrary = sized arb
    where arb 0 = oneof [liftM Numb arbitrary,
                         liftM Atom (liftM2 (:) (elements ['a'..'z'])
                                                 arbitraryString)]
          arb n = oneof [arb 0,
                         liftM (foldr Cons (Atom "nil"))
                                (resize (n `div` 3) arbitrary)]
prop_sexp_string s = take 1 (parse sexp (string s)) == [s]

main = quickCheck prop_sexp_string
