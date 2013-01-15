
xor False x = x
xor True  x = not x

bits 0 = []
bits n = (n `mod` 2 /= 0) : bits (n `div` 2)

show True = "Group A"
show False = "Group B"

group = foldr xor False . bits 

myPersonNumber = 197812150666
myGroup = group myPersonNumber

