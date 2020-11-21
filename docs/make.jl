push!(LOAD_PATH, "../src/")

using Documenter, POMDPModelTools

makedocs(
    modules = [POMDPModelTools],
    format = Documenter.HTML(),
    sitename = "POMDPModelTools.jl",
    expandfirst = ["index.md"],
    pages = ["index.md", filter(f->first(f)!='.'&&f!="index.md", readdir("src"))...] # Show home first
)

deploydocs(
    repo = "github.com/JuliaPOMDP/POMDPModelTools.jl.git",
)
