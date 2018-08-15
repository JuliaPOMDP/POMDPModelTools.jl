using POMDPModelTools
using POMDPs
using POMDPModels
using Distributions
using Random
using Test

include("test_ordered_spaces.jl")
include("test_generative_belief_mdp.jl")
include("test_implementations.jl")
include("test_distributions_jl.jl")
include("test_weighted_iteration.jl")
include("test_sparse_cat.jl")
include("test_bool.jl")
include("test_info.jl")
include("test_obs_weight.jl")

# # following tests require DiscreteValueIteration
# POMDPs.add("DiscreteValueIteration")
# using DiscreteValueIteration
# include("test_fully_observable_pomdp.jl")
# include("test_underlying_mdp.jl")
