Imp.
====

In this part of the exam, we use the following notation: 

* `* q` means: memory cell whose adress is `q`. (Note that `q` must be an address)
* `& a` means: address of `a`. (Note that `a` must be an l-value)


Q1. (4 pts)

Which of the following these expressions are l-values? Which expressions are adresses?
(`a`, `b` denote rational numbers variables; `p`, `q` denote addresses of rational numbers variables.)

Reproduce the following table and replace the question marks with "yes" or "no" appropriately.

 expression  l-value        address
 ----------  --------       --------
 a           ?              ?               
 p           ?              ?
 a + 1       ?              ?
 & a         ?              ?
 & p         ?              ?
 * p         ?              ?



----------------------

Q2. (4 pts)

Consider the following program. It uses the "call by reference" calling convention; and copy semantics for assignment.

~~~~~~~~~~~~~~~~~~~~~
f (a, b : integers passed by reference) {    
    a := b;
    b := b + 3;
    return;
}

x, y: integer
x := 2;
y := 4;
f(x,y);
x := y + 1;
print (x + y);
~~~~~~~~~~~~~~~~~~~~~



What is printed?

Translate the function `f` *and* its call to a language that does not
support call by reference, but only call by value. Do so using pointers
(use operators `*` and `&`). You are not allowed to change anything
else. In particular, the "algorithm" and the declatations of `x` and `y` must
remain the same.

Alt: other calling conventions.

Q3.

A program `P` contains a function `f`.

`f` has one integer parameter (`x`) and no return value.

At some point of the execution of the program, the memory contains three active
copies of the activation record of `f`.

Write `P`, satisfying the above conditions. (2pts)

Draw the 3 activation records at the point considered above. (x pts)

Do not forget the return address! Indicate the return address with an arrow pointing in the
source code.(2pts)


Q4. 

Give one reason to keep a pointer to the AR of the caller.
Give one reason to keep a pointer to the AR of the lexically enclosing function.





OO
===

Q1. 

State the substitution principle of Liskov. (3pts) 

I claim that every type is a subtype of itself. Show that this claim is compatible with 
the above statement (your answer to the above question) by specialising it. (3pts)

Q2. 

class Bag<A> {
    contains : A -> Bool
    insert : A
}

class Fruit ...
class Apple  extends Fruit ...
class Orange extends Fruit ...


Assume that a A :< B => Bag<A> :< Bag<B>

Write a program that shows that the rule is not sound. (3pts)

Orange o
Bag<Apple> ba

% Bag<Fruit>(ba).insert (o)

// here the bag of apples contains an orange!


I argue that A :< B => Bag<A> :< Bag<B> is missing a side condition for it to be correct.

State such a side condition. (3 pts)


Q3. 

Assume the following subtyping statements:

$Cat :< Animal$, $Dog :< Animal$, $Terrier :< Dog$

Given the above, which of the following subtyping statements are sound
with respect to the substitution principle?  (We have seen general
rules for sound subtyping in class, apply them to the following
examples)



  label     statement
 -------  -------------------------------------------------
                 Cat :< Dog
                 Terrier :< Animal 
    a         Animal -> Dog        :<   Dog -> Animal
    b         Dog -> Animal        :<   Animal -> Dog
    c         Animal -> Animal     :<   Dog -> Dog
    d         Terrier -> Terrier   :<   Dog -> Dog
              { mutable  f : Dog } :<   { mutable  f : Animal }
              { constant f : Dog } :<   { constant f : Animal }
              { mutable  f : Dog } :<   { }
              { }                  :< { mutable  f : Dog } 
              { constant  f : Dog } :<   { }
              { }                  :< { constant  f : Dog } 


Q4.  Algebraic specification.

Consider the following axioms to describe semantics of a sort `S`.

~~~~~~~~~~~~~~~~
contains (x, empty) = false
contains (x, insert (x,s)) = true
contains (x, insert (y,s)) = contains (x, s) (assuming x /= y)
remove (x, empty) = empty
remove (x, insert (x,s)) = s
remove (x, insert (y,s)) = insert (y, remove (x,s)) (assuming x /= y)
insert (x, insert (y,s)) = insert (y, insert (x,s))
~~~~~~~~~~~~~~~~

Write the signature for all operations of the sort `S`. (Assume the sort `Element` for elements, that
Booleans are pre-defined)

True or false: an ADT which implements for this specification must remember the
number of times that an element is inserted.

By adding an axiom to the above specification, I can change the answer to the above question.
Write down this axiom.

