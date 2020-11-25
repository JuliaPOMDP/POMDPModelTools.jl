push!(LOAD_PATH, "../src/")

using Documenter, POMDPModelTools

mdfiles = filter(f -> first(f) != '.', readdir(joinpath(dirname(@__FILE__), "src")))

makedocs(
    modules = [POMDPModelTools],
    format = Documenter.HTML(),
    sitename = "POMDPModelTools.jl",
    expandfirst = ["index.md"],
    pages = ["index.md", filter(!=("index.md"), mdfiles)...] # Show home first
)

deploydocs(
    repo = "github.com/JuliaPOMDP/POMDPModelTools.jl.git",
)
