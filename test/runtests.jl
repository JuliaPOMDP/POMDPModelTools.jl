using POMDPModelTools
using POMDPs
# using POMDPModels
using Distributions
using Random
using Test

@testset "ordered" begin
    include("test_ordered_spaces.jl")
end

## XXX Need POMDPModels
# @testset "genbeliefmdp" begin
#     include("test_generative_belief_mdp.jl")
# end
@testset "implement" begin
    include("test_implementations.jl")
end
@testset "distribjl" begin
    include("test_distributions_jl.jl")
end
@testset "weightediter" begin
    include("test_weighted_iteration.jl")
end
@testset "sparsecat" begin
    include("test_sparse_cat.jl")
end
@testset "bool" begin
    include("test_bool.jl")
end

## XXX Need POMDPModels
# @testset "info" begin
#     include("test_info.jl")
# end
@testset "obsweight" begin
    include("test_obs_weight.jl")
end

# # following tests require DiscreteValueIteration
# POMDPs.add("DiscreteValueIteration")
# @testset "visolve" begin
#     using DiscreteValueIteration
#     include("test_fully_observable_pomdp.jl")
#     include("test_underlying_mdp.jl")
# end
