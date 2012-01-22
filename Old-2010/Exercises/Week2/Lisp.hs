import ParserLibrary
import Test.QuickCheck
import Monad
import Data.Char

data SExp = Numb Int 
          | Atom String
          | Cons SExp SExp
            deriving (Show, Eq)


sample0 = Cons (Numb 2) (Atom "nil")
sample1 = Cons (Numb 1) (Cons (Numb 2) (Atom "nil"))
sample2 = Cons (Cons (Numb 2) (Atom "nil")) (Cons (Numb 1)  (Atom "nil"))

-- 1.
stringP p (Numb i) = show i
stringP p (Atom s) = s
stringP p (Cons h (Atom "nil")) = (if p then paren else id) (string h)
stringP p (Cons h t) = (if p then paren else id) (string h ++ " " ++ stringP False t)

string = stringP True

paren x = "(" ++ x ++ ")"

-- Parser:

sexp = error "fill this"


-- Tests


arbitraryChar = elements (['a'..'z']++['0'..'9'])
arbitraryString = oneof [return [], liftM2 (:) arbitraryChar arbitraryString]

instance Arbitrary SExp where
  arbitrary = sized arb
    where arb 0 = oneof [liftM Numb arbitrary,
                         liftM Atom (liftM2 (:) (elements ['a'..'z']) arbitraryString)]
          arb n = oneof [arb 0,
                         liftM (foldr Cons (Atom "nil"))
                                (resize (n `div` 3) arbitrary)]
prop_sexp_string s = take 1 (parse sexp (string s)) == [s]

main = quickCheck prop_sexp_string
