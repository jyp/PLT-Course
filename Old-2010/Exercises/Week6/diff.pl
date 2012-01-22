fromList([],d(X,X)).
fromList([A|As],d(A:Out,In)) :- fromList(As,d(Out,In)).

toList(d(Rest,Rest),[]):-!.
toList(d(Head:Tail,Diff),[Head|OtherTail]) :- toList(d(Tail,Diff),OtherTail).

dconcat(d(Out,Intermediate),d(Intermediate,In),d(Out,In)).

append([],Ys,Ys).
append([X|Xs],Ys,[X|Zs]):- append(Xs,Ys,Zs).
