using MovingWindowArrays
using Documenter

DocMeta.setdocmeta!(MovingWindowArrays, :DocTestSetup, :(using MovingWindowArrays); recursive=true)

makedocs(;
    modules=[MovingWindowArrays],
    authors="Simeon David Schaub <simeon@schaub.rocks> and contributors",
    sitename="MovingWindowArrays.jl",
    format=Documenter.HTML(;
        canonical="https://simeonschaub.github.io/MovingWindowArrays.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/simeonschaub/MovingWindowArrays.jl",
    devbranch="main",
)
