

fromList([],d(X,X)).
fromList([A|As],d(A:Out,In)) :- fromList(As,d(Out,In)).

toList(d(X,[]),X).

toListAlt(X,Y) :- fromList(Y,X).

dconcat(d(Out,Intermediate),d(Intermediate,In),d(Out,In)).
% dconcat(d(Out2,In2),d(Out1,In1),d(Out,In)) :- Out = Out2, In2 = Out1, In = In1.