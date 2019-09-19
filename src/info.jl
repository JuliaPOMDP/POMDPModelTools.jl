# functions for passing out info from simulations, similar to the info return from openai gym
# maintained by @zsunberg

"""
    a, ai = action_info(policy, x)

Return a tuple containing the action determined by policy 'p' at state or belief 'x' and information (usually a `NamedTuple`, `Dict` or `nothing`) from the calculation of that action.

By default, returns `nothing` as info.
"""
function action_info(p::Policy, x)
    return action(p, x), nothing
end

"""
    policy, si = solve_info(solver, problem)

Return a tuple containing the policy determined by a solver and information (usually a `NamedTuple`, `Dict` or `nothing`) from the calculation of that policy.

By default, returns `nothing` as info.
"""
function solve_info(s::Solver, problem::Union{POMDP,MDP})
    return solve(s, problem), nothing
end

"""
    bp, i = update_info(updater, b, a, o)

Return a tuple containing the new belief and information (usually a `NamedTuple`, `Dict` or `nothing`) from the belief update.

By default, returns `nothing` as info.
"""
function update_info(up::Updater, b, a, o)
    return update(up, b, a, o), nothing
end

# once POMDPs v0.8 is released, this should be a jldoctest
"""
    add_infonode(ddn::DDNStructure)

Create a new DDNStructure object with a new node labeled :info for returning miscellaneous informationabout a simulation step.

Typically, the object in info is associative (i.e. a `Dict` or `NamedTuple`) with keys corresponding to different pieces of information.

# Example (using POMDPs v0.8)

```julia
using POMDPs, POMDPModelTools, POMDPPolicies, POMDPSimulators, Random

struct MyMDP <: MDP{Int, Int} end

# add the info node to the DDN
POMDPs.DDNStructure(::Type{MyMDP}) = mdp_ddn() |> add_infonode

# the dynamics involve two random numbers - here we record the values for each in info
function POMDPs.gen(m::MyMDP, s, a, rng)
    r1 = rand(rng)
    r2 = randn(rng)
    return (sp=s+a+r1+r2, r=s^2, info=(r1=r1, r2=r2))
end

m = MyMDP()
@show nodenames(DDNStructure(m))
p = FunctionPolicy(s->1)
for (s,info) in stepthrough(m, p, 1, "s,info", max_steps=5, rng=MersenneTwister(2))
    @show s
    @show info 
end
```
"""
function add_infonode(ddn) # for DDNStructure, but it is not declared in v0.7.3, so there is not annotation
    add_node(ddn, :info, ConstantDDNNode(nothing), nodenames(ddn))
end

function add_infonode(ddn::POMDPs.DDNStructureV7{nodenames}) where nodenames
    return POMDPs.DDNStructureV7{(nodenames..., :info)}()
end

###############################################################
# Note all generate functions will be deprecated in POMDPs v0.8
###############################################################


if DDNStructure(MDP) isa POMDPs.DDNStructureV7
    """
    Return a tuple containing the next state and reward and information (usually a `NamedTuple`, `Dict` or `nothing`) from that step.

    By default, returns `nothing` as info.
    """
    function generate_sri(p::MDP, s, a, rng::AbstractRNG)
        return generate_sr(p, s, a, rng)..., nothing
    end

    """
    Return a tuple containing the next state, observation, and reward and information (usually a `NamedTuple`, `Dict` or `nothing`) from that step.

    By default, returns `nothing` as info. 
    """
    function generate_sori(p::POMDP, s, a, rng::AbstractRNG)
        return generate_sor(p, s, a, rng)..., nothing
    end

    POMDPs.gen(::DDNOut{(:sp,:o,:r,:i)}, m, s, a, rng) = generate_sori(m, s, a, rng)
    POMDPs.gen(::DDNOut{(:sp,:o,:r,:info)}, m, s, a, rng) = generate_sori(m, s, a, rng)
    POMDPs.gen(::DDNOut{(:sp,:r,:i)}, m, s, a, rng) = generate_sri(m, s, a, rng)
    POMDPs.gen(::DDNOut{(:sp,:r,:info)}, m, s, a, rng) = generate_sri(m, s, a, rng)
else
    @deprecate generate_sri(args...) gen(DDNOut(:sp,:r,:info), args...)
    @deprecate generate_sori(args...) gen(DDNOut(:sp,:o,:r,:info), args...)
end
