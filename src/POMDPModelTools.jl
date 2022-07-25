module POMDPModelTools

Base.depwarn("""
             Functionality from POMDPModelTools has been moved to POMDPTools.

             Simply replace `using POMDPModelTools` with `using POMDPTools`.
             """, :POMDPModelTools)

using Reexport
using Random: AbstractRNG
import POMDPs

import POMDPTools

@reexport using POMDPTools.ModelTools
@reexport using POMDPTools.POMDPDistributions
@reexport using POMDPTools.Policies: evaluate
@reexport using POMDPTools.CommonRLIntegration

policy_reward_vector = POMDPTools.Policies.policy_reward_vector
mean_reward = POMDPTools.ModelTools.mean_reward

# convenient implementations
include("convenient_implementations.jl")

export
    add_infonode
include("deprecated.jl")

end # module
