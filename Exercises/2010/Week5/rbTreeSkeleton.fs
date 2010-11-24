module pp.rbtree

type Color = 
    | Red 
    | Black

type RBTree =
    | Leaf 
    | Node of Color * RBTree * int * RBTree

let empty = Leaf

let rec isElement y tree =
  (* complete *)


let balance col left el right =
  (* complete *)

let insert x tree =
   let rec ins tree =
     (* complete *)

   let makeBlack tree = 
     match tree with
     | Node(_,left, y, right) -> Node(Black, left, y, right)   (* the other case cannot happen *)
   makeBlack (ins tree)
 

(* queries *)

let rec rbSum(tree:RBTree) =
     (* complete *)


let rec rbSize(tree:RBTree) =
     (* complete *)

let rec rbDepth(tree:RBTree) =
     (* complete *)



(* tests *)

let rec constructTree elList tree = 
    match elList with
    | x::xs -> constructTree xs (insert x tree)
    | []   -> tree


(* immutable set *)
type ImmutableIntSet(tree:RBTree) = 
   (* complete *)

   new() = new ImmutableIntSet(empty)  (*define empty constructor*)


(* mutable set *)
type MutableIntSet(tree:RBTree) = 
   (* complete *)

   new() = new MutableIntSet(empty) (* define empty constructor *)

