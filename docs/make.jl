using RollingWindowArrays
using Documenter

DocMeta.setdocmeta!(RollingWindowArrays, :DocTestSetup, :(using RollingWindowArrays); recursive = true)

makedocs(;
    modules = [RollingWindowArrays],
    authors = "Simeon David Schaub <simeon@schaub.rocks> and contributors",
    sitename = "RollingWindowArrays.jl",
    format = Documenter.HTML(;
        canonical = "https://simeonschaub.github.io/RollingWindowArrays.jl",
        edit_link = "main",
        assets = String[],
    ),
    pages = [
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo = "github.com/simeonschaub/RollingWindowArrays.jl",
    devbranch = "main",
)
