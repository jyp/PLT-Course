split([],[],[]).
split([X|A],[X|P],N) :- split(A,P,N).
split([X|A],P,[X|N]) :- split(A,P,N).

splitt([],[],[]).
splitt([X|A],[X|P],N) :- X >  0 , splitt(A,P,N).
splitt([X|A],P,[X|N]) :- X =< 0 , splitt(A,P,N).

