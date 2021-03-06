# Model Transformations

POMDPModelTools contains several tools for transforming problems into other classes so that they can be used by different solvers.

## Sparse Tabular MDPs and POMDPs

The `SparseTabularMDP` and `SparseTabularPOMDP` represents discrete problems defined using the explicit interface. The transition and observation models are represented using sparse matrices. Solver writers can leverage these data structures to write efficient vectorized code. A problem writer can define its problem using the explicit interface and it can be automatically converted to a sparse tabular representation by calling the constructors `SparseTabularMDP(::MDP)` or `SparseTabularPOMDP(::POMDP)`. See the following docs to know more about the matrix representation and how to access the fields of the `SparseTabular` objects:

```@docs
SparseTabularMDP
SparseTabularPOMDP
transition_matrix
reward_vector
observation_matrix
transition_matrices
reward_matrix
observation_matrices
```

## Fully Observable POMDP

```@docs
FullyObservablePOMDP
```

## Generative Belief MDP

Every POMDP is an MDP on the belief space `GenerativeBeliefMDP` creates a generative model for that MDP.

!!! warning
    The reward generated by the `GenerativeBeliefMDP` is the reward for a *single state sampled from the belief*; it is not the   expected reward for that belief transition (though, in expectation, they are equivalent of course). Implementing the model with the expected reward requires a custom implementation because belief updaters do not typically deal with reward.

```@docs
GenerativeBeliefMDP
```

### Example

```@meta
DocTestSetup = quote
    using Pkg
    Pkg.add("POMDPModels")
    Pkg.add("BeliefUpdaters")
    # the thing below should be a jldoctest once POMDPSimulators gets registered
end
```

```julia
using POMDPModels
using POMDPModelTools
using BeliefUpdaters

pomdp = BabyPOMDP()
updater = DiscreteUpdater(pomdp)

belief_mdp = GenerativeBeliefMDP(pomdp, updater)
@show statetype(belief_mdp) # POMDPModels.BoolDistribution

for (a, r, sp) in stepthrough(belief_mdp, RandomPolicy(belief_mdp), "a,r,sp", max_steps=5)
    @show a, r, sp
end
```

```@meta
DocTestSetup = nothing
```

## Underlying MDP

```@docs
UnderlyingMDP
```

## State Action Reward Model

```@docs
StateActionReward
```
