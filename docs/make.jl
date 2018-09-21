using Documenter, POMDPModelTools

makedocs(
    modules = [BeliefUpdaters],
    format = :html,
    sitename = "POMDPModelTools.jl"
)

deploydocs(
    repo = "github.com/JuliaPOMDP/POMDPModelTools.jl.git",
    julia = "1.0",
    osname = "linux",
    target = "build",
    deps = nothing,
    make = nothing
)

