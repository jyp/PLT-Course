{-
   for (int i=0;i<sizeof(a);i++)
     if (a[i].grade >= 24)
       *b++ = a[i]
-}

f     = filter ((>= 24) . grade)

f' xs = [ x | x <- xs, grade x >= 24 ]

