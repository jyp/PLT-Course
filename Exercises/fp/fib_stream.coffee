
zipStream = (f, {head:x, tail:t}, {head:y, tail:s}) ->
    { head: f(x, y)
    , tail: thunk(() -> zipStream(f, t(), s()))
    }

thunk = (f) ->
    x = undefined
    () -> if x == undefined then x = f() else x

force = (t) -> t()

tailStream = ({head:_, tail:t}) -> force(t)

fibs =
    { head:0
    , tail: thunk(() ->
            { head:1
            , tail: thunk( () -> zipStream(((x, y) -> x + y), fibs, tailStream(fibs)))
            }
        )
    }

forceStream = ({head:x, tail:t},n) -> if n == 0 then [] else [x].concat(forceStream(force(t),n-1))

console.log(forceStream(fibs,30))

