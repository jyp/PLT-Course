%append(I-M, M-O, I-O).

%fromList([], X).
%fromList([A|As], [Y|Ys]) :- fromList(As, Ys).


dconcat(I-M, M-O, I-O).

toList(X-_, Y) :- toList(X, Y).
toList([_], [ ]).
toList([A|As], [A|Bs]) :- toList(As, Bs).



fromList(X, DD) :- append(X,[O], Y),
	DD = Y-O.

append([], Ys, Ys).
append([X|Xs], Ys, [X|Zs]) :- append(Xs, Ys, Zs).
