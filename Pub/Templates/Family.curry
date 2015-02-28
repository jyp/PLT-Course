-- Database programming in Curry: family relationships

data Person = Adolf | Sybilla | Gustaf | Silvia | Victoria | Philip | Madeleine
parent :: Person -> Person -> Success
parent Adolf Gustaf = success




















-- parents :: Person -> [Person]
-- grandparent :: Person -> Person -> Success
-- sibling :: Person -> Person -> Success
-- cousin :: Person -> Person -> Success

data Gender = Male | Female

gender :: Person -> Gender
gender Adolf = Male
gender Gustaf = Male
gender Sybilla = Female
gender Silvia = Female
gender Madeleine = Female
gender Victoria = Male
gender Philip = Male


-- male :: Person -> Success
-- female :: Person -> Success
-- father :: Person -> Person -> Success
-- mother :: Person -> Person -> Success






