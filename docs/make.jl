# Build docs from repository root, e.g. with
# 
#    julia --project=docs/ docs/make.jl
#
# Serve docs this repository root to serve:
#
#   julia -e 'using LiveServer; serve(dir="docs/build")'julia -e 'using LiveServer; serve(dir="docs/build")' 
#
using Pkg
Pkg.activate(".")
Pkg.instantiate()

using Documenter, DocStringExtensions, GedCom

makedocs(
    sitename = "GedCom.jl Documentation",
    pages = [
        "Home" => "index.md"
    ]
)

deploydocs(
    repo = "github.com/neelsmith/GedCom.jl.git",
) 
