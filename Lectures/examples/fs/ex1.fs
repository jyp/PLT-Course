module pp

let sum x y =
    x + y

(* sum 4 5 *)

(* partial function application *)

let inc = sum 1

(* delegate definition *)

let binOp (f: int -> int -> int) x y =
     f x y

binOp 4 5



let incBy y =
    let step = 1
    sum y step