push!(LOAD_PATH, "../src/")

using Documenter, POMDPModelTools

makedocs(
    modules = [POMDPModelTools],
    format = Documenter.HTML(),
    sitename = "POMDPModelTools.jl"
)

deploydocs(
    repo = "github.com/JuliaPOMDP/POMDPModelTools.jl.git",
)
