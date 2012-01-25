module poly   (* declares module *)

open System    (* imports System module *)
open System.IO (* imports System.IO module *)


(* Defines a record type *)
type Point2D = { x : float; y: float }


(* Defines a discriminated union *)
type Shape =
    | Circle    of Point2D * Point2D
    | Rectangle of Point2D * Point2D


type Color =
    | RGB of int * int * int
    | YMUV of int * int * int * int


type CRectangle(upperLeft:Point2D, lowerRight:Point2D, col:Color) =
    static let mutable counter = 0

    let ul = upperLeft
    let ur = lowerRight
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
let rect = new Rectangle({x=100.0; y=100.0}, {x=200.0; y=110.0})
rect.Area

