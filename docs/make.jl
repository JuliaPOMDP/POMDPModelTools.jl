push!(LOAD_PATH, "../src/")

using Documenter, POMDPModelTools

makedocs(
    modules = [POMDPModelTools],
    format = :html,
    sitename = "POMDPModelTools.jl"
)

deploydocs(
    repo = "github.com/JuliaPOMDP/POMDPModelTools.jl.git",
)
