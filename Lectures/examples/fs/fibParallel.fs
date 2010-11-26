let rec fib t x =
   printf "task %d \n" t
   match x with
    | 0 -> 1
    | 1 -> 2
    | n -> fib t (x - 1) + fib t (x - 2)

let task1 n  = async { return fib 1 n }
let task2 n  = async { return fib 2 n }

let fibTwoTasksInParallel = Async.Parallel[task1 5; task2 10] 

let result = Async.RunSynchronously(fibTwoTasksInParallel)

let fibs =
    Async.Parallel [ for i in 0 .. 8 -> async { return fib i (i) } ]
    |> Async.RunSynchronously
