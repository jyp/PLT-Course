let mul x (y:int byref) = x * y
let mutable factor = 2
let dup = mul factor

let mulRef x y = !x * y
let factorRef = ref 2
let dupRef = mulRef factorRef

dup 5    (* value? *)
dupRef 5 (* value? *)

factor <- 3
factorRef := 3






















let mul (x:int byref) y = x * y
let mutable factor = 2
let dup    = mul &factor

dup 5

factor <- 4

dup 5
