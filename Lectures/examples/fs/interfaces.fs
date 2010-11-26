module pp.interfaces

(* Defines a record type *)
type Point2D = { x : float; y: float }


(* Defines a discriminated union *)
type Shape =
    | Circle    of Point2D * Point2D
    | Rectangle of Point2D * Point2D


type Color =
    | RGB of int * int * int
    | YMUV of int * int * int * int


(* interfaces *)

type IColored = interface
  abstract member Color: Color
end 

type IShape =
 abstract member Area: float


(* implementing class *)
type CRectangle(upperLeft:Point2D, lowerRight:Point2D, col:Color) =
    let mutable color = col
    interface IColored with
        member self.Color = color
    interface IShape with
        member self.Area = (lowerRight.x - upperLeft.x) * (lowerRight.y - upperLeft.y)

(* invoking *)
let rect = new CRectangle({x=100.0; y=100.0}, {x=200.0; y=110.0}, RGB(0,0,0))

rect.Area (* does it work? *)
