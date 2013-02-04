
data A -- = ... (whatever definition works)
data B
data C




-- (A + B)×C  ­->  A×C + B×C

data AplusB = TagA A | TagB B

data ACplusBC = TagAC A C | TagBC B C

f :: (AplusB,C) -> ACplusBC
f = error "todo"

g :: ACplusBC -> (AplusB,C)
g = error "todo"