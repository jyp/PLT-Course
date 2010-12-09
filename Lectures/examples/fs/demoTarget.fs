module poly   (* declares module *)

open System    (* imports System module *)
open System.IO (* imports System.IO module *)


(* Defines a record type *)
type Point2D = { x : float; y: float }

let addP (p1:Point2D) (p2:Point2D) = {x=p1.x+p2.x; y=p1.y + p2.y}  

(* Defines a discriminated union *)
type Shape =
    | Circle    of Point2D * float
    | Rectangle of Point2D * Point2D


type Color =
    | RGB of int * int * int
    | YMUV of int * int * int * int


let computeArea shape =
    match shape with
        | Rectangle(ul, lr) -> (lr.x - ul.x) * (lr.y - ul.y)
        | Circle(center, radius) -> 3.14*radius*radius

let computeCircumfence shape =
    match shape with
        | Rectangle(ul, lr) -> 2.0*((lr.x - ul.x) + (lr.y - ul.y))
        | Circle(center, radius) -> 2.0*3.14*radius

let move shape v =
    match shape with
        | Rectangle(ul, lr) -> Rectangle(addP ul v, addP lr v)
        | Circle(center, radius) -> Circle(addP center v, radius)
    
(* imperative *)
let moveRel origRect moveVec (current:Point2D byref) =
    current <- addP current moveVec
    move origRect current 

(* introducing classes *)

type CRectangle(upperLeft:Point2D, lowerRight:Point2D, col:Color) =
    static let mutable counter = 0

    let ul = upperLeft
    let lr = lowerRight
    let mutable color = col

    do
        counter <- counter + 1

    new(ul, lr) = CRectangle(ul, lr, RGB(0,0,0)) 

    member self.Area =
        (lowerRight.x - upperLeft.x) * (lowerRight.y - upperLeft.y)
    member self.Circumference =
        2.0 * ((lowerRight.x - upperLeft.x) + (lowerRight.y - upperLeft.y))
    member self.Color(col:Color) = color <- col




(* short tests *)

let y = computeArea (Circle({x=10.0; y=10.0}, 10.0))

let ourRect = Rectangle({x=100.0; y=100.0}, {x=200.0; y=110.0})
let shiftRight = {x=20.0; y=0.0}

move ourRect {x=20.0; y=0.0}

let mutable currentMove = shiftRight

while currentMove.x < 300.0 do
    printf "%f >> " currentMove.x
    ignore (moveRel ourRect shiftRight &currentMove)


let rect = new CRectangle({x=100.0; y=100.0}, {x=200.0; y=110.0})
rect.Area

(* useful function *)
let g = new System.Random()
let nextRand = g.NextDouble

let generateRectangles n =
    [ for i in 1..n do
        let xR = nextRand() * 100.0
        let yR = nextRand() * 100.0
        let width = nextRand() * 100.0
        let height = nextRand() * 100.0
        yield Rectangle({x=xR; y=yR}, {x=xR+width; y=yR+height}) ]

let rectSet = generateRectangles 100

List.map computeArea rectSet
List.map computeCircumfence rectSet


(* async *)

let asyncAreaTask rects = async { return List.map computeArea rects }
let asyncCircTask rects = async { return List.map computeCircumfence rects }

let taskGroup r = Async.Parallel[asyncAreaTask r; asyncCircTask r]

Async.RunSynchronously(taskGroup rectSet)
