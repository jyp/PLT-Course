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
     | Node(_,left, y, right) -> Node(Black, left, y, right)   (* the other case cannot happen *)
   makeBlack (ins tree)
 

(* queries *)

let rec rbSum(tree:RBTree) =
    match tree with
    | Node(_, l, x, r) -> rbSum l + rbSum r + x 
    | Leaf -> 0


let rec rbSize(tree:RBTree) =
    match tree with
    | Node(_, l, x, r) -> 1 + rbSize l + rbSize r 
    | Leaf -> 0  (* we do not count leaves as they do not carry elements *) 

let rec rbDepth(tree:RBTree) =
    match tree with
    | Leaf -> 1
    | Node(_, l, _, r) -> 
       let leftDepth  = rbDepth l
       let rightDepth = rbDepth r 
       if leftDepth > rightDepth then leftDepth + 1
       else rightDepth + 1


(* tests *)

let rec constructTree elList tree = 
    match elList with
    | x::xs -> constructTree xs (insert x tree)
    | []   -> tree


(* uncomment:
let tree1 = constructTree [1..5] empty
let tree2 = constructTree [1..100] empty
let tree3 = constructTree [1..10000] empty

*)

(*
tree1: rbSum: 15; rbDepth: 4; rbSize: 5 
tree2: rbSum: 5050; rbDepth: 10; rbSize: 100
tree3: rbSum: 50005000; rbDepth: 19 rbSize: 10000
*)

(* asynchronous *)

let compDepth tree = async { return rbDepth tree } 
let compSize  tree = async { return rbSize tree } 
let compSum   tree = async { return rbSum tree } 



let computeAll tree = Async.Parallel[compDepth tree; compSize tree; compSum tree]


(* The following line, best to show in fsi

Async.RunSynchronously (computeAll tree3) ;;

*)



(* immutable set *)
type ImmutableIntSet(tree:RBTree) = 
   let rbBacked = tree
   new() = new ImmutableIntSet(empty)

   member v.Size() = rbSize rbBacked
   member v.Depth() = rbDepth rbBacked
   member v.HasElement(el:int) = isElement el rbBacked 
   member v.Add(el:int) = new ImmutableIntSet(insert el rbBacked)

(* mutable set *)
type MutableIntSet(tree:RBTree) = 
   let mutable rbBacked = tree
   new() = new MutableIntSet(empty)

   member v.Size() = rbSize rbBacked
   member v.Depth() = rbDepth rbBacked
   member v.HasElement(el:int) = isElement el rbBacked 
   member v.Add(el:int) = rbBacked <- insert el rbBacked


(* test *)
let emptySet = new ImmutableIntSet()
let immSet1 = emptySet.Add(1)

let emptyMutSet = new MutableIntSet()
emptyMutSet.Add(1)
