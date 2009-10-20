Imp.
====


`* q` means: memory cell whose adress is `q`. (`q` must be an address)

`& a` means: address of a, (`a` must be an l-value)

Consider the following declarations:

`a, b : memory cell for a rational number`
`p, q : address of a rational number`

Q1. (4 pts)

Which of the following these expressions are l-values? (2pts) Which expressions are adresses? (2pts)

                        l-value        pointer
a                        
p
a + 1
& a
& p
* p



----------------------

Q2. (4 pts)

Consider the following program written using
references. It assumes call-by-value semantics.

f (a, b : reference to integer) returns reference to integer {    
    t : reference to integer

    t := a
    a := b
    return t
}


x, y: integer

...

print (f (x, y) + x)


Translate the function `f` and its call to a language that does not support
references, by using pointers. You are not allowed to change the "algorithm". 


Q3.

A program `P` contains a function `f`.

`f` has one integer parameter (`x`) and no return value.

At some point of the execution of the program, the memory contains three active
copies of the activation record of `f`.

Write `P`, satisfying the above conditions. (2pts)

Draw the 3 activation records at the point considered above. (x pts)

Do not forget the return address! Indicate the return address with an arrow pointing in the
source code.(2pts)


Q4. When/why do you need a pointer to the previous AR?

OO
===

Q1. 

State the Liskov substitution principle. (3pts) 
Specifiy the above principle to justify that subtyping is a reflexive relation.  (3pts)

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

// here ba.contains(o)


Can you add a condition on the rule 


I argue that the rule A :< B => Bag<A> :< Bag<B> is missing a side condition,
in terms of mutability.

State such a side condition. (3 pts)

Q3. 