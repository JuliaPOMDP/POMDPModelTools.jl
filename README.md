# POMDPModelTools

[![Build Status](https://travis-ci.org/JuliaPOMDP/POMDPModelTools.jl.svg?branch=master)](https://travis-ci.org/JuliaPOMDP/POMDPModelTools.jl)
[![Coverage Status](https://coveralls.io/repos/github/JuliaPOMDP/POMDPModelTools.jl/badge.svg?branch=master)](https://coveralls.io/github/JuliaPOMDP/POMDPModelTools.jl?branch=master)
[![Latest Docs](https://img.shields.io/badge/docs-latest-blue.svg)](https://JuliaPOMDP.github.io/POMDPModelTools.jl/latest)

Support tools for writing [POMDPs.jl](github.com/JuliaPOMDP/POMDPs.jl) models and solvers.

## Installation

This package requires [POMDPs.jl](https://github.com/JuliaPOMDP). To install this module run the following command:

```julia
add POMDPModelTools
```

## Code structure

Within src each file contains one tool. Each file should clearly indicate who is the maintainer of that file.

## Tools


### Convenience
#### [`implementations.jl`](src/convenient_implementations.jl)
Default implementations for simple cases (e.g. `states(::MDP{Bool, Bool})`).

### Distributions
#### [`distributions_jl.jl`](src/distributions/distributions_jl.jl)
Provides some compatibility with [Distributions.jl](https://github.com/JuliaStats/Distributions.jl).

#### [`sparse_cat.jl`](src/distributions/sparse_cat.jl)
Provides a sparse categorical distribution `SparseCat`. This distribution simply stores a vector of objects and a vector of their associated probabilities. It is optimized for value iteration with a fast implementation of `weighted_iterator`. Both `pdf` and `rand` are order n.

Example: `SparseCat([1,2,3], [0.1,0.2,0.7])` is a categorical distribution that assignes probability 0.1 to `1`, 0.2 to `2`, 0.7 to `3`, and 0 to all other values.

#### [`weighted_iteration.jl`](src/distributions/weighted_iteration.jl)
Function for iterating through pairs of values and their probabilities in a distribution.

#### [`bool.jl`](src/distributions/bool.jl)
Distribution over an outcome being true. Create with `BoolDistribution(p_true)`. Obviously, the probability of false is simply `1 - p_true`.

### Info
#### [`info.jl`](src/info.jl)
Contains a small interface for outputting extra information (usually a `Dict` or `nothing`) from simulations.
- `sp, o, r, info = generate_sori(pomdp, s, a, rng)` and `sp, r, info = generate_sri(mdp, s, a, rng)` can be implemented to output info from the model when it simulates a step.
- `a, ainfo = action_info(policy, x)` can be implemented to output info from the policy when it chooses an action.
- `policy, sinfo = solve_info(solver, problem)` can be implemented to output info from the solver when it solves a POMDP or MDP.
The action info and transition info can be accessed by simulating with `HistoryRecorder` and using `eachstep(hist, "i,ai")` or with `stepthrough(..., "i,ai")`.

### Generative Belief MDP
#### [`generative_belief_mdp.jl`](src/generative_belief_mdp.jl)
Transforms a pomdp (and a belief updater) into a belief-space MDP.

Example (note that the states of the belief MDP are beliefs):
```julia
using POMDPModels
using POMDPModelTools
using BeliefUpdaters

pomdp = BabyPOMDP()
updater = DiscreteUpdater(pomdp)

belief_mdp = GenerativeBeliefMDP(pomdp, updater)
@show statetype(belief_mdp) # POMDPModels.BoolDistribution

for (a, r, sp) in stepthrough(belief_mdp, RandomPolicy(belief_mdp), "a,r,sp", max_steps=10)
    @show a, r, sp
end
```

### Ordered spaces
#### [`ordered_spaces.jl`](src/ordered_spaces.jl)
Contains 3 functions, `ordered_states`, `ordered_actions`, and `ordered_observations` that return vectors of all the items in a space correctly ordered according to the respective index function. For example `ordered_actions(mdp)` will return a vector `v`, containing all of the actions in `actions(mdp)` in the order such that  `action_index(mdp, v[i]) == i`.

### Testing
#### [`model_test.jl`](src/model_test.jl)
Generic functions for testing POMDP models.
