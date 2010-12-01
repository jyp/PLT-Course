class(Number,positive) :- print('applying rule positive'),Number > 0.
class(0,zero):- print('applying rule zero').
class(Number, negative) :- print('applying rule negative'), Number < 0.


classs(Number,positive) :- print('applying rule positive'),Number > 0,!.
classs(0,zero):- print('applying rule zero'),!.
classs(Number, negative) :- print('applying rule negative'), Number < 0,!.

classss(Number,positive) :- print('applying rule positive'),Number > 0,!.
classss(0,zero):- print('applying rule zero'),!.
classss(Number, negative) :- print('applying rule negative'),!.
