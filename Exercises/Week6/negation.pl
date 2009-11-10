
elem(X,[X|_]).
elem(X,[_|Xs]) :- elem(X,Xs).

neg(Goal) :- Goal,!,fail.
neg(Goal).

diff([],Ys,[]).
diff([X|Xs],Ys,Zs)     :- elem(X,Ys),       diff(Xs,Ys,Zs).
diff([X|Xs],Ys,[X|Zs]) :- neg(elem(X,Ys)),  diff(Xs,Ys,Zs).

like(sven,Language) :- neg(Language = prolog).
