
data Value = A | K | Q | N | Ten | Nine | Eight | Seven | Six | Five | Four | Three | Two

type Hand = [Value]

fourOfAKind hand | hand =:= x++y:z & (x++z) =:= [r,r,r,r] = r
  where x,y,z,r free
