# these functions return vectors of states, actions and observations, ordered according to state_index, action_index, etc.

"""
    ordered_actions(mdp)    

Return an `AbstractVector` of actions ordered according to `action_index(mdp, a)`.

`ordered_actions(mdp)` will always return an `AbstractVector{A}` `v` containing all of the actions in `actions(mdp)` in the order such that `action_index(mdp, v[i]) == i`. You may wish to override this for your problem for efficiency.
"""
ordered_actions(mdp::Union{MDP,POMDP}) = ordered_vector(actiontype(typeof(mdp)), a->action_index(mdp,a), actions(mdp), n_actions(mdp), "action")

"""
    ordered_states(mdp)    

Return an `AbstractVector` of states ordered according to `state_index(mdp, a)`.

`ordered_states(mdp)` will always return a `AbstractVector{A}` `v` containing all of the states in `states(mdp)` in the order such that `state_index(mdp, v[i]) == i`. You may wish to override this for your problem for efficiency.
"""
ordered_states(mdp::Union{MDP,POMDP}) = ordered_vector(statetype(typeof(mdp)), s->state_index(mdp,s), states(mdp), n_states(mdp), "state")

"""
    ordered_observations(pomdp)    

Return an `AbstractVector` of observations ordered according to `obs_index(pomdp, a)`.

`ordered_observations(mdp)` will always return a `AbstractVector{A}` `v` containing all of the observations in `observations(pomdp)` in the order such that `obs_index(pomdp, v[i]) == i`. You may wish to override this for your problem for efficiency.
"""
ordered_observations(pomdp::POMDP) = ordered_vector(obstype(typeof(pomdp)), o->obs_index(pomdp,o), observations(pomdp), n_observations(pomdp), "observation")

function ordered_vector(T::Type, index::Function, support, len, singular, plural=singular*"s")
    a = Array{T}(undef, len)
    gotten = falses(len)
    for x in support
        id = index(x)
        if id > len || id < 1
            error("""
                  $(singular)_index(...) returned an index that was out of bounds for $singular $x.

                  index was $id.

                  n_$plural(...) was $len.
                  """)
        end
        a[id] = x
        gotten[id] = true
    end
    if !all(gotten)
        missing = findall(.!gotten)
        @warn """
             Problem creating an ordered vector of $plural in ordered_$plural(...). There is likely a mistake in $(singular)_index(...) or n_$plural(...).

             n_$plural(...) was $len.

             $plural corresponding to the following indices were missing from support($plural(...)): $missing
             """
    end
    return a
end

@POMDP_require ordered_actions(mdp::Union{MDP,POMDP}) begin
    P = typeof(mdp)
    @req action_index(::P, ::actiontype(P))
    @req n_actions(::P)
    @req actions(::P)
    as = actions(mdp)
end

@POMDP_require ordered_states(mdp::Union{MDP,POMDP}) begin
    P = typeof(mdp)
    @req state_index(::P, ::statetype(P))
    @req n_states(::P)
    @req states(::P)
    as = states(mdp)
end

@POMDP_require ordered_observations(mdp::Union{MDP,POMDP}) begin
    P = typeof(mdp)
    @req obs_index(::P, ::obstype(P))
    @req n_observations(::P)
    @req observations(::P)
    as = observations(mdp)
end
