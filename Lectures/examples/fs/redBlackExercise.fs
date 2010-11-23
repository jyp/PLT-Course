module pp.rbtree

type Color = 
    | Red 
    | Black

type RBTree =
    | Leaf 
    | Node of Color * RBTree * int * RBTree

let empty = Leaf

let rec isElement y tree =
    match tree with
    | Leaf -> false 
    | Node(_, left, x, right) when x < y -> isElement y right 
    | Node(_, left, x, right) when x = y -> true
    | Node(_, left, x, right) when x > y -> isElement y left 

let balance col left el right =
  match (col, left, el, right) with 
  | (Black, Node(Red, Node(Red, a, x, b), y, c), z, d) 
    | (Black, Node(Red, a, x, Node(Red, b, y, c)), z, d)
    | (Black, a, x, Node(Red, Node(Red, b, y, c), z, d))
    | (Black, a, x, Node(Red, b, y, Node(Red, c, z, d))) -> Node(Red, Node(Black, a, x, b),y,Node(Black, c, z, d)) 
  | _ -> Node(col, left, el, right)

let insert x tree =
   let rec ins tree =
     match tree with
     | Leaf  -> Node(Red, Leaf, x, Leaf)    
     | Node(color, left, y, right) when x < y -> balance color (ins left) y right  
     | Node(color, left, y, right) when x = y -> Node(color, left, y, right)
     | Node(color, left, y, right) when x > y -> balance color left y (ins right)  
   let makeBlack tree = 
     match tree with
     | Node(_,left, y, right) -> Node(Black, left, y, right)
   makeBlack (ins tree)
 

let rec rbSum(tree:RBTree) =
    match tree with
    | Node(_, l, x, r) -> rbSum l + rbSum r + x 
    | Leaf -> 0
