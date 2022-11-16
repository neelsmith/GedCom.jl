# Build docs from repository root, e.g. with
# 
#    julia --project=docs/ docs/make.jl
#
# Serve docs from repository root:
#
#   julia -e 'using LiveServer; serve(dir="docs/build")'
#
using Pkg
Pkg.activate(".")
Pkg.instantiate()

using Documenter, DocStringExtensions, GedCom

makedocs(
    sitename = "GedCom.jl Documentation",
    pages = [
        "Home" => "index.md",
        "Individuals" => "individuals.md",
        "Families" => "families.md",
        "Sources" => "sources.md",
        "Locations" => "locations.md",
        
        "Extracting data" => "datablocks.md"
    ]
)

deploydocs(
    repo = "github.com/neelsmith/GedCom.jl.git",
) 
