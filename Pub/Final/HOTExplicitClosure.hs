

data Point = Point Float Float
(.+.) :: Point -> Point -> Point
Point x1 y1 .+. Point x2 y2 = Point (x1 + x2) (y1 + y2)

opposite :: Point -> Point
opposite (Point x y) = Point (negate x) (negate y)

(.-.) :: Point -> Point -> Point
p1 .-. p2 = p1 .+. opposite p2

norm2 :: Point -> Float
norm2 (Point x y) = x*x + y*y


-- type Region = Point -> Bool
data Region = Outside Region
            | Intersect Region Region
            | Within Float Point

apply :: Region -> Point -> Bool
apply (Outside r) p       = not (apply r p)
apply (Intersect r1 r2) p = r1 p && r2 p
apply (Within range p1) p2 = norm2 (p1 .-. p2) <= range * range

outside :: Region -> Region
outside r = Outside r

(∩) :: Region -> Region -> Region
r1 ∩ r2 = Intersect r1 r2

withinRange :: Float -> Point -> Region
withinRange range p1 p2 = Within range p1 p2

-- engagementZone :: Point -> Region
-- engagementZone p = withinRange 30 p ∩ outside (withinRange 10 p)

