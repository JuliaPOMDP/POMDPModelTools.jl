using Documenter, POMDPModelTools

makedocs(
    # format=:html,
    # sitename = "POMDPModelTools",
    # pages = [
    #          "About" => "index.md",
    #          "Distributions"=>"distributions.md",
    #          # "Distribution Tools"=>"distribution_tools.md",
    #          # "Terminal States"=>"terminal.md",
    #          # "Info Interface"=>"info.md",
    #          # "Ordered Spaces"=>"ordered.md",
    #          # "Convenience"=>"convenience.md",
    #          # "Testing"=>"testing.md",
    #          ]
    )

deploydocs(
           deps = Deps.pip("mkdocs"),
           repo = "github.com/JuliaPOMDP/POMDPModelTools.jl",
           julia = "1.0"
          )
