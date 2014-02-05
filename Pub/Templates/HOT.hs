

type Point = (Float,Float)
type Region = Point -> Bool

(.+.) :: Point -> Point -> Point
(x1,y1) .+. (x2,y2) = (x1 + x2, y1 + y2)

opposite :: Point -> Point
opposite (x,y) = (negate x, negate y)

(.-.) :: Point -> Point -> Point
p1 .-. p2 = p1 .+. opposite p2

norm2 :: Point -> Float
norm2 (x,y) = x*x + y*y

outside :: Region -> Region
outside r pt = not (r pt)

(∧) :: Region -> Region -> Region
(r1 ∧ r2) pt = r1 pt && r2 pt

within :: Float -> Point -> Region
within range from target = norm2 (from .-. target) < range^2

engagementZone :: Point -> Region
engagementZone from = within 10 from ∧ outside (within 8 from)

