"""
    FullyObservablePOMDP(mdp)

Turn `MDP` `mdp` into a `POMDP` where the observations are the states of the MDP.
"""
struct FullyObservablePOMDP{M,S,A} <: POMDP{S,A,S}
    mdp::M
end

function FullyObservablePOMDP(m::MDP)
    return FullyObservablePOMDP{typeof(m), statetype(m), actiontype(m)}(m)
end
mdptype(::Type{FullyObservablePOMDP{M,<:Any,<:Any}}) where M = M

function POMDPs.DDNStructure(::Type{M}) where M <: FullyObservablePOMDP
    MM = mdptype(M)
    add_node(DDNStructure(MM), :o, FunctionDDNNode((m,sp)->sp), :sp)
end

POMDPs.observations(pomdp::FullyObservablePOMDP) = states(pomdp.mdp)
POMDPs.obsindex(pomdp::FullyObservablePOMDP{S, A}, o::S) where {S, A} = stateindex(pomdp.mdp, o)

POMDPs.convert_o(T::Type{V}, o, pomdp::FullyObservablePOMDP) where {V<:AbstractArray} = convert_s(T, s, pomdp.mdp)
POMDPs.convert_o(T::Type{S}, vec::V, pomdp::FullyObservablePOMDP) where {S,V<:AbstractArray} = convert_s(T, vec, pomdp.mdp)


POMDPs.gen(::DDNVar{:o}, m::FullyObservablePOMDP, sp, rng) = sp

function POMDPs.observation(pomdp::FullyObservablePOMDP, a, sp)
    return Deterministic(sp)
end

function POMDPs.observation(pomdp::FullyObservablePOMDP, s, a, sp)
    return Deterministic(sp)
end

# inherit other function from the MDP type

POMDPs.states(pomdp::FullyObservablePOMDP) = states(pomdp.mdp)
POMDPs.actions(pomdp::FullyObservablePOMDP) = actions(pomdp.mdp)
POMDPs.transition(pomdp::FullyObservablePOMDP{S,A}, s::S, a::A) where {S,A} = transition(pomdp.mdp, s, a)
POMDPs.initialstate_distribution(pomdp::FullyObservablePOMDP) = initialstate_distribution(pomdp.mdp)
POMDPs.initialstate(pomdp::FullyObservablePOMDP, rng::AbstractRNG) = initialstate(pomdp.mdp, rng)
POMDPs.isterminal(pomdp::FullyObservablePOMDP, s) = isterminal(pomdp.mdp, s)
POMDPs.discount(pomdp::FullyObservablePOMDP) = discount(pomdp.mdp)
POMDPs.stateindex(pomdp::FullyObservablePOMDP{S,A}, s::S) where {S,A} = stateindex(pomdp.mdp, s)
POMDPs.actionindex(pomdp::FullyObservablePOMDP{S, A}, a::A) where {S,A} = actionindex(pomdp.mdp, a)
POMDPs.convert_s(T::Type{V}, s, pomdp::FullyObservablePOMDP) where V<:AbstractArray = convert_s(T, s, pomdp.mdp)
POMDPs.convert_s(T::Type{S}, vec::V, pomdp::FullyObservablePOMDP) where {S,V<:AbstractArray} = convert_s(T, vec, pomdp.mdp)
POMDPs.convert_a(T::Type{V}, a, pomdp::FullyObservablePOMDP) where V<:AbstractArray = convert_a(T, a, pomdp.mdp)
POMDPs.convert_a(T::Type{A}, vec::V, pomdp::FullyObservablePOMDP) where {A,V<:AbstractArray} = convert_a(T, vec, pomdp.mdp)

POMDPs.gen(d::DDNOut, m::FullyObservablePOMDP, s, a, rng) = gen(d, m.mdp, s, a, rng)
POMDPs.gen(d::DDNNode, m::FullyObservablePOMDP, args...) = gen(d, m.mdp, args...)
POMDPs.gen(m::FullyObservablePOMDP, s, a, rng) = gen(m.mdp, s, a, rng)


# deprecated in POMDPs v0.8
POMDPs.generate_s(pomdp::FullyObservablePOMDP, s, a, rng::AbstractRNG) = generate_s(pomdp.mdp, s, a, rng)
POMDPs.generate_sr(pomdp::FullyObservablePOMDP, s, a, rng::AbstractRNG) = generate_sr(pomdp.mdp, s, a, rng)
POMDPs.reward(pomdp::FullyObservablePOMDP{S, A}, s::S, a::A) where {S,A} = reward(pomdp.mdp, s, a)
POMDPs.n_actions(pomdp::FullyObservablePOMDP) = n_actions(pomdp.mdp)
POMDPs.n_states(pomdp::FullyObservablePOMDP) = n_states(pomdp.mdp)
function POMDPs.generate_o(pomdp::FullyObservablePOMDP, s, rng::AbstractRNG)
    return s
end
