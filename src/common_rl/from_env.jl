abstract type AbstractRLEnvMDP{S, A} <: MDP{S, A} end
abstract type AbstractRLEnvPOMDP{S, A, O} <: POMDP{S, A, O} end

const AbstractRLEnvProblem = Union{AbstractRLEnvMDP, AbstractRLEnvPOMDP}

POMDPs.actions(m::AbstractRLEnvProblem) = RL.actions(m.env)
POMDPs.discount(m::AbstractRLEnvProblem) = m.discount

struct RLEnvMDP{E, S, A} <: AbstractRLEnvMDP{S, A}
    env::E
    discount::Float64
end

function RLEnvMDP(env, discount=1.0)
    S = try
            only(Base.return_types(RL.state, Tuple{typeof(env)}))
        catch ex
            @warn("""Unable to infer state type for $(typeof(env)) because of the following error:

                  $(sprint(showerror, ex))
                  
                  Falling back to Any.
                  """)
            Any
        end
    if S == Any
        @warn("State type inferred for $(typeof(env)) by looking at the return type of state(env) was Any. This could cause significant performance degradation.")
    end
    return RLEnvMDP{typeof(env), S, eltype(RL.actions(env))}(env, discount)
end

function POMDPs.actions(m::RLEnvMDP, s)
    if provided(RL.valid_actions, m.env)
        RL.setstate!(m.env, s)
        return RL.valid_actions(m.env)
    else
        return RL.actions(m.env)
    end
end

function POMDPs.initialstate(m::RLEnvMDP)
    return ImplicitDistribution(m) do m, rng
        RL.reset!(m.env)
        return RL.state(m.env)
    end
end

function POMDPs.gen(m::RLEnvMDP, s, a, rng)
    # rng is not currently used
    RL.setstate!(m.env, s)
    r = RL.act!(m.env, a)
    sp = RL.state(m.env)
    return (sp=sp, r=r)
end

function POMDPs.isterminal(m::RLEnvMDP, s)
    RL.setstate!(m.env, s)
    return RL.terminated(m.env)
end

struct OpaqueRLEnvState
    age::BigInt
end

mutable struct OpaqueRLEnvMDP{E, A} <: AbstractRLEnvMDP{OpaqueRLEnvState, A}
    env::E
    age::BigInt
    discount::Float64
end

function OpaqueRLEnvMDP(env, discount=1.0)
    return OpaqueRLEnvMDP{typeof(env), eltype(RL.actions(env))}(env, 1, discount)
end

function POMDPs.actions(m::OpaqueRLEnvMDP, s::OpaqueRLEnvState)
    if provided(RL.valid_actions, m.env) && s.age == m.age
        return RL.valid_actions(m.env)
    else
        return RL.actions(m.env)
    end
end

function POMDPs.initialstate(m::OpaqueRLEnvMDP)
    return ImplicitDistribution(m) do m, rng
        RL.reset!(m.env)
        m.age += 1
        return OpaqueRLEnvState(m.age)
    end
end

function POMDPs.gen(m::OpaqueRLEnvMDP, s::OpaqueRLEnvState, a, rng)
    if s.age == m.age
        r = RL.act!(m.env, a)
        m.age += 1
        return (sp=OpaqueRLEnvState(m.age), r=r)
    else
        throw(OpaqueRLEnvState(m.env, m.age, s))
    end
end

function POMDPs.isterminal(m::OpaqueRLEnvMDP, s::OpaqueRLEnvState)
    if s.age != m.age
        throw(OpaqueRLEnvState(m, s))
    end
    return RL.terminated(m.env)
end


# XXX Below = work in progress
struct RLEnvPOMDP{E, S, A, O} <: AbstractRLEnvPOMDP{S, A, O}
    env::E
    discount::Float64
end

struct OpaqueRLEnvPOMDP{E, A, O} <: AbstractRLEnvPOMDP{OpaqueRLEnvState, A, O}
    env::E
    age::BigInt
    discount::Float64
end


# function Base.convert(::Type{POMDP}, ::RL.AbstractEnv)
#     
# end



function Base.convert(::Type{MDP}, env)
    if RL.provided(RL.state, env)
        s = RL.state(env)
        if RL.provided(RL.setstate!, env, s)
            return RLEnvMDP(env)
        end
    end
    return OpaqueRLEnvMDP(env)
end

struct OpaqueRLEnvStateError <: Exception
    env
    env_age::BigInt
    s::OpaqueRLEnvState
end

function Base.showerror(io::IO, e::OpaqueRLEnvStateError)
    print(io, "OpaqueRLEnvStateError: ")
    print(io, """An attempt was made to interact with the environment encapsulated in an `OpaqueRLEnv(PO)MDP` at a particular state, but the environment had been stepped forward, so it may be in a different state.

              Enironment age: $(e.env_age)
              State age: $(e.s.age)
                
              Suggestions: provide `CommonRLInterface.state(::$(typeof(e.env)))` and `CommonRLInterface.setstate!(::$(typeof(e.env)), s)` so that the environment can be converted to a `RLEnv(PO)MDP` instead of an `OpaqueRLEnv(PO)MDP`.
              """)
end
