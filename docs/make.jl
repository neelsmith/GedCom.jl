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
Pkg.resolve()
Pkg.instantiate()

using Documenter, DocStringExtensions, GedCom

makedocs(
    sitename = "GedCom.jl Documentation",
    pages = [
        "Home" => "index.md",
        "Genealogies" => "genealogies.md",
        "Individuals" => "individuals.md",
        "Families" => "families.md",
        "Sources" => "sources.md",
        "Locations" => "locations.md",
        
        "Working directly with GEDCOM records" => "datablocks.md"
    ]
)

deploydocs(
    repo = "github.com/neelsmith/GedCom.jl.git",
) 
