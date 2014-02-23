import AllSolutions

data Color = Red | Green | Blue | Yellow

neighbour :: Color -> Color -> Success
neighbour x y | x /= y = success

n = neighbour

southSweden (bohus,skane,blekinge,o,sma,hal,dals,og,vg) =
   n skane blekinge
 & n blekinge o
 & n o sma
 & n hal skane
 & n hal sma
 & n hal bohus
 & n hal vg
 & n bohus dals
 & n bohus vg
 & n vg sma
 & n vg og
 & n sma og
 & n o og
 & n vg dals
 & n bohus dals

main = getOneSolution southSweden
