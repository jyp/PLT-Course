data Bin = Leaf | Bin

t1 = 2 =:= 2

t2 = 1 =:= 2

t3 = x =:= 2 where x free

t4 = 2 =:= x where x free


t5 = [x,1] =:= [2,y] where x,y free


t6 = [] =:= [x,y] where x,y free


t7 = x =:= y & y =:= 2 where x,y free

t8a = [x,y,z] =:= [x,x,y] where x,y,z free

t8 = [x,y,z] =:= [2,x,y] where x,y,z free

