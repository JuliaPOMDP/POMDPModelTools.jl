using POMDPModelTools
using POMDPModels
@static if VERSION < v"0.7.0-DEV.2005"
    using Base.Test
else
    using Test
end

include("test_ordered_spaces.jl")
include("test_generative_belief_mdp.jl")
include("test_implementations.jl")
include("test_distributions.jl")
include("test_weighted_iteration.jl")
include("test_sparse_cat.jl")
include("test_bool.jl")
include("test_info.jl")
include("test_fully_observable_pomdp.jl")
include("test_underlying_mdp.jl")
include("test_obs_weight.jl")
