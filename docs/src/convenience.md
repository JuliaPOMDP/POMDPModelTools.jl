# Convenience

POMDPModelTools contains default implementations for some POMDPs.jl functions, including `actions`, `n_actions`, `action_index`, etc. for some obvious cases. This allows some obvious implementations to be skipped.

For instance, if an MDP with a Bool action type is created, the obvious `actions` method is already implemented:

```jldoctest
julia> using POMDPs; using POMDPModelTools

julia> struct BoolMDP <: MDP{Bool, Bool} end

julia> actions(BoolMDP())
(true, false)
```

For a complete list of default implementations, see [convenient_implementations.jl](https://github.com/JuliaPOMDP/POMDPModelTools.jl/blob/master/src/convenient_implementations.jl).
