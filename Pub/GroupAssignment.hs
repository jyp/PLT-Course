
xor False x = x
xor True  x = not x

bits 0 = []
bits n = (n `mod` 2 /= 0) : bits (n `div` 2)

sho True = "Group A"
sho False = "Group B"

group = foldr xor False . bits 

myPersonNumber = 197812150666
myGroup = sho $ group myPersonNumber

