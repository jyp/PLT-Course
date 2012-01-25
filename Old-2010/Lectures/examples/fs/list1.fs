module pp
open pp

let rec sumList list =
  match list with 
    | head :: tail -> head + sumList tail 
    | [] -> 0

