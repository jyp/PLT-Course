fromList([], d(X,X)).
fromList([A|As], d([A|Out],In)) :− fromList(As, d(Out,In)).
