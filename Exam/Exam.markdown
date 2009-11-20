Imp.
====


`* q` means: memory cell whose adress is `q`. (`q` must be an address)

`& a` means: address of a, (`a` must be an l-value)

Consider the following declarations:

`a, b : memory cell for a rational number`
`p, q : address of a rational number`

Q1. (4 pts)

Which of the following these expressions are l-values? (2pts) Which expressions are adresses? (2pts)

Reproduce the following table and tick the appropriate cells.

                        l-value        address
a                        
p
a + 1
& a
& p
* p



----------------------

Q2. (4 pts)

Consider the following program. It uses the call by reference calling convention.

f (a, b : integers passed by reference) {    
    a := b
    b := b + 3;
    return t
}


x, y: integer

f(x,y)

x := y + 1;
print (x + y);


What is printed?

Translate the function `f` and its call to a language that does not support
call by reference, but only call by value, by using pointers (use operators * and &). You are not allowed to change anything else. In particular, the "algorithm", the declatations of x and y must remain the same.

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