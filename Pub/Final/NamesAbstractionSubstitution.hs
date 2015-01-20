
import  Prelude hiding (pi)

pi = 3.141592

diskArea r = r * r * pi

ringArea r1 r2 = diskArea r2 - diskArea r1

area = ringArea 20 30

-- what can be named?
-- what can be abstracted over?
-- recover the original by substitution.
-- pitfall: name capture. (and other kind of side effects!)
