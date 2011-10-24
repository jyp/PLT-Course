-- Database programming in Curry: family relationships
-- (functional logic style with explicit functional dependencies)

data Person = GustafAdolf | Sybilla | CarlGustaf | Silvia | Victoria | CarlPhilip | Madeleine
data Gender = Male | Female

parent :: Person -> Person -> Success
parent GustafAdolf   CarlGustaf = success
parent Sybilla       CarlGustaf = success

parent CarlGustaf    Victoria   = success
parent CarlGustaf    CarlPhilip = success
parent CarlGustaf    Madeleine  = success

parent Silvia        Victoria   = success
parent Silvia        CarlPhilip = success
parent Silvia        Madeleine  = success



---- We can ask who is a parent; who is a child...

-- query: parent CarlGustaf x where x free


-- exercises: define grandparent, grandgrandparent, ancestor, descendents



sibling x y :: Person -> Person -> Success
sibling x y = parent z x & parent z y


-- exercise: cousin

{-

gender :: Person -> Gender
gender Jack = Male
gender CarlGustaf = Male
gender Catherine = Female
gender Victoria = Male
gender CarlPhilip = Male

male :: Person -> Success
male x = gender x =:= Male
female x = gender x =:= Female

father :: Person -> Person -> Success
father y x = male y & parent y x

mother :: Person -> Person -> Success
mother y x = female y & parent y x
-}




