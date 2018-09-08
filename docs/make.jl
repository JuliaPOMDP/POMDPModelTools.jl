using Documenter, POMDPModelTools

makedocs()

deploydocs(
           deps = Deps.pip("mkdocs"),
           repo = "github.com/JuliaPOMDP/POMDPModelTools.jl",
           julia = "1.0"
          )
