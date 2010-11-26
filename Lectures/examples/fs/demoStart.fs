module poly   (* declares module *)

open System    (* imports System module *)
open System.IO (* imports System.IO module *)

(* Some helpers *)
let g = new System.Random()
let nextRand = g.NextDouble

let generateRectangles n =
    [ for i in 1..n do
        let xR = nextRand() * 100.0
        let yR = nextRand() * 100.0
        let width = nextRand() * 100.0
        let height = nextRand() * 100.0
        yield Rectangle({x=xR; y=yR}, {x=xR+width; y=yR+height}) ]

(* Defines a record type *)
type Point2D = { x : float; y: float }

let addP (p1:Point2D) (p2:Point2D) = {x=p1.x+p2.x; y=p1.y + p2.y}  




(* Playground *)


















































(* fibo *)
let rec fib n = 
    printf "Called with %d \n" n
    if n <= 2 then 1 
    else fib (n - 1) + fib (n - 2)
