# Pipe


## Usage
Load the package via
```julia
using Pipe: @pipe
```
(Just doing `using Pipe` will give an error about a name conflict with the `Base.Pipe` type.)

Place `@pipe` at the start of the line for which you want "advanced piping functionality" to work.

This works the same as Julia piping,
except if you place a underscore in the right-hand expression, 
it will be replaced with the result of the left-hand expression.

So:
```julia
@pipe a |> b(x,_)       # b(x,a)    NOT: (b(x,_))(a) 
```

Futher the `_` can be unpacked, called, deindexed, etc.
```julia
@pipe a |> b(_...)      # b(a...)
@pipe a |> b(_(1, 2))   # b(a(1,2))
@pipe a |> b(_[3])      # b(a[3])
```

This last can be used for interacting with multiple returned values. In general, however, this is frowned upon.
Generally, a pipeline is good for expressing a logical flow data through Single Input Single Output functions. 
When you deindex multiple times, that is case of working with Multiple Input Multiple Output functions.

In that case it is likely more clear to create named variables, and call the functions normally in sequence.
There is also a performace cost for doing multiple deindexes (see below).

For example:

```julia
function get_angle(rise, run)
    atan(rise / run)
end

@pipe (2,4) |> get_angle(_[1],_[2]) # 0.4636476090008061
get_angle(2,4)                      # 0.4636476090008061 (Note: the ordinary way is much clearer)
```

However, for each `_` in the right hand side of the `|>`, the left hand side will be called.
This can incur a performance cost.

```julia
function ratio(value, lr, rr)
    println("slitting on ratio $lr:$rr")
    value * lr / (lr + rr), value * rr / (lr + rr)
end

function percent(left, right)
    left / right * 100
end

@pipe 10 |> ratio(_,4,1) |> percent(_[1],_[2]) # 400.0, outputs splitting on ratio 4:1 Twice
@pipe 10 |> ratio(_,4,1) |> percent(_...)      # 400.0, outputs splitting on ratio 4:1 Once
```

---------------------

## See Also:

 - [List of similar/related works](https://github.com/JuliaLang/julia/issues/5571#issuecomment-205754539)
