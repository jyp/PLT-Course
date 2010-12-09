module poly   (* declares module *)

open System    (* imports System module *)
open System.IO (* imports System.IO module *)

(* Some helpers *)

(* Defines a record type *)
type Point2D = { x : float; y: float }

let addP (p1:Point2D) (p2:Point2D) =
    {x=p1.x+p2.x; y=p1.y + p2.y}  

type Shape =
    | Rectangle of Point2D * Point2D
    | Circle of Point2D * float

let ourCirc = Circle({x=10.0; y=10.0}, 10.0)
let ourRect = Rectangle({x=100.0; y=100.0}, {x=200.0; y=110.0})

let computeArea shape =
    match shape with
        | Rectangle(ul, lr) -> (lr.x - ul.x) * (lr.y - ul.y)
        | Circle(c, r) -> 3.14 * r * r

let computeCircumfence shape =
    match shape with
        | Rectangle(ul, lr) -> 2.0*((lr.x - ul.x) + (lr.y - ul.y))
        | Circle(center, radius) -> 2.0*3.14*radius


let g = new System.Random()
let nextRand = g.NextDouble

let generateRectangles n =
    [ for i in 1..n do
        let xR = nextRand() * 100.0
        let yR = nextRand() * 100.0
        let width = nextRand() * 100.0
        let height = nextRand() * 100.0
        yield Rectangle({x=xR; y=yR}, {x=xR+width; y=yR+height}) ]

let ourRects = generateRectangles 5

let move shape v =
    match shape with
        | Rectangle(ul, lr) -> Rectangle(addP ul v, addP lr v)
        | Circle(center, radius) -> Circle(addP center v, radius)
    

let mutable movementVec = {x=0.0; y=0.0}
movementVec <- {x=0.0; y=0.0}

let shiftRight = {x=20.0; y=0.0}

move ourRect {x=10.0; y=10.0}





(* Playground *)
let x = 10

let sum x y = x + y
sum 5 9

let y = System.Console.ReadLine()
let myRead = System.Console.ReadLine
myRead()


let rec fib n =
    printf "%d \n" n
    if n <= 2 then 1
    else fib(n-2) + fib(n-1)

fib 3
