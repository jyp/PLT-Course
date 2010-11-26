module pp

type Color =
    | Red
    | Black

type Tree  =
    | Leaf 
    | Node of Color * Tree * Tree

let tree0 = Leaf
let tree1 = Node(Black, Leaf, Leaf)
let tree2 = Node(Black, Node(Red, Leaf, Leaf), Node(Red, Leaf, Leaf))

let rec countRed tree =
    match tree with
    | Leaf -> 0
    | Node(Red, left, right) ->
         1 + countRed(left) + countRed(right)
    | Node(Black, left, right) ->
         0 + countRed(left) + countRed(right)

let y = countRed tree2

let dir = new System.IO.DirectoryInfo(@"/Users/bubel")

let files = [for i in dir.GetFiles(@"*") -> i.]

let natNumbers = Seq.unfold (fun i -> Some(i, i + 1)) 0
for i in 80..90 do printf "%d" Seq.nth i natNumbers
