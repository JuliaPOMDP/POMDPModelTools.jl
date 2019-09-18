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

"""
    add_infonode(ddn::DDNStructure)

Create a new DDNStructure object with a new node labeled :info with parents :s and :a
"""
function add_infonode(ddn) # for DDNStructure, but it is not declared in v0.7.3, so there is not annotation
    add_node(ddn, :info, ConstantDDNNode(nothing), (:s, :a))
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
