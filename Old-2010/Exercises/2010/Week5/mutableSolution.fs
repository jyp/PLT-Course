(* (a) Which of the statements below are legal *)

let x = 7
let mutable xMut = 7
let xRef = ref 7

x <- 10   (* not valid *)
x := 10   (* not valid *)

xRef := 10  (* valid *)
XMut <- 10  (* not valid *)

let y = x   (* valid *)
let y = !xMut (* not valid *)
let y = !xRef (* valid *)

(* (b) *)

let x = 7
let mutable xMut = 7
let xRef = ref 7

let divide x y = x / y
let divideRef x y = 
    y := divide x !y
    !y
let divideImp x (y:int byref) = 
    y <- divide x y
    y


(* (b1) Is the expression below legal? If yes, what is the value of res1, x, xMut, xRef afterwards? *)
let res1 = divide 42 7

(* solution: res1 is 6; all other unchanged *)

(* (b2) Is the expression below legal? If yes, what is the value of res2, x, xMut, xRef afterwards? *)
let res2 = divide 42 x
(* solution: res2 is 6; all other unchanged *)


(* (b3) Is the expression below legal? If yes, what is the value of res3, x, xMut, xRef afterwards? *)
let res3 = divideRef 42 x
(* solution: illegal *)


(* (b4) Is the expression below legal? If yes, what is the value of res4, x, xMut, xRef afterwards? *)
let res4 = divideRef 42 (ref 7)
(* solution: res4 is 6, all unchanged )


(* (b5) Is the expression below legal? If yes, what is the value of res5, x, xMut, xRef afterwards? *)
let res5 = divideRef 42 xRef
(* solution: res4 is 6, !xRef is 6 (xRef still same reference cell, but changed content))

(* (b6) Is the expression below legal? If yes, what is the value of res6, x, xMut, xRef afterwards? *)
let res6 = divideImp 42 &xMut
(* solution: res6 is 6 and xMut is 6   *)