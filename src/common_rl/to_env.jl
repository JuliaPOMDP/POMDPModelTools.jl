const RL = CommonRLInterface

abstract type AbstractPOMDPsCommonRLEnv <: RL.AbstractMarkovEnv end

RL.actions(env::AbstractPOMDPsCommonRLEnv) = actions(env.m)
RL.terminated(env::AbstractPOMDPsCommonRLEnv) = isterminal(env.m, env.s)

mutable struct MDPCommonRLEnv{RLO, M<:MDP, S} <: AbstractPOMDPsCommonRLEnv
    m::M
    s::S
end

MDPCommonRLEnv{RLO}(m, s) where {RLO} = MDPCommonRLEnv{RLO, typeof(m), typeof(s)}(m, s)

function RL.reset!(env::MDPCommonRLEnv)
    env.s = rand(initialstate(env.m))
    return nothing
end

function RL.act!(env::MDPCommonRLEnv, a)
    sp, r = @gen(:sp, :r)(env.m, env.s, a)
    env.s = sp
    return r
end

RL.observe(env::MDPCommonRLEnv{RLO}) where {RLO} = convert_s(RLO, env.s, env.m)

RL.@provide RL.clone(env::MDPCommonRLEnv{RLO}) where {RLO} = MDPCommonRLEnv{RLO}(env.m, env.s)
RL.@provide RL.render(env::MDPCommonRLEnv) = render(env.m, (sp=env.s,))
RL.@provide RL.state(env::MDPCommonRLEnv{RLO}) where {RLO} = convert_s(RLO, env.s, env.m)
RL.@provide RL.valid_actions(env::MDPCommonRLEnv) = actions(env.m, env.s)
RL.@provide RL.observations(env::MDPCommonRLEnv{RLO}) where {RLO} = (convert_s(RLO, s, env.m) for s in states(env.m)) # should really be some kind of lazy map that handles uncountably infinite spaces


RL.@provide function RL.setstate!(env::MDPCommonRLEnv{<:Any, <:Any, S}, s) where S
    env.s = convert_s(S, s, env.m)
    return nothing
end

mutable struct POMDPCommonRLEnv{RLO, M<:POMDP, S, O} <: AbstractPOMDPsCommonRLEnv
    m::M
    s::S
    o::O
end

POMDPCommonRLEnv{RLO}(m, s, o) where {RLO} = POMDPCommonRLEnv{RLO, typeof(m), typeof(s), typeof(o)}(m, s, o)

function RL.reset!(env::POMDPCommonRLEnv)
    env.s = rand(initialstate(env.m))
    env.o = rand(initialobs(env.m, env.s))
    return nothing
end

function RL.act!(env::POMDPCommonRLEnv, a)
    sp, o, r = @gen(:sp, :o, :r)(env.m, env.s, a)
    env.s = sp
    env.o = o
    return r
end

RL.observe(env::POMDPCommonRLEnv{RLO}) where {RLO} = convert_o(RLO, env.o, env.m)

RL.@provide RL.clone(env::POMDPCommonRLEnv{RLO}) where {RLO} = POMDPCommonRLEnv{RLO}(env.m, env.s, env.o)
RL.@provide RL.render(env::POMDPCommonRLEnv) = render(env.m, (sp=env.s, o=env.o))
RL.@provide RL.state(env::POMDPCommonRLEnv) = (env.s, env.o)
RL.@provide RL.valid_actions(env::POMDPCommonRLEnv) = actions(env.m, env.s)
RL.@provide RL.observations(env::POMDPCommonRLEnv{RLO}) where {RLO} = (convert_o(RLO, o, env.m) for o in observations(env.m)) # should really be some kind of lazy map that handles uncountably infinite spaces

RL.@provide function RL.setstate!(env::POMDPCommonRLEnv, so)
    env.s = first(so)
    env.o = last(so)
    return nothing
end

function Base.convert(::Type{RL.AbstractMarkovEnv}, m::POMDP)
    s = rand(initialstate(m))
    o = rand(initialobs(m, s))
    return POMDPCommonRLEnv{AbstractArray}(m, s, o)
end

function Base.convert(::Type{RL.AbstractMarkovEnv}, m::MDP)
    s = rand(initialstate(m))
    return MDPCommonRLEnv{AbstractArray}(m, s)
end

Base.convert(::Type{MDP}, env::MDPCommonRLEnv) = env.m
Base.convert(::Type{POMDP}, env::POMDPCommonRLEnv) = env.m

Base.convert(::Type{RL.AbstractEnv}, m::Union{MDP,POMDP}) = convert(RL.AbstractMarkovEnv, m)
