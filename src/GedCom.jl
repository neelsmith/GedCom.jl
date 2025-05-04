module GedCom

import Base: ==
import Base: show
using Graphs
using SimpleValueGraphs


#using CairoMakie

using Documenter
using DocStringExtensions

include("gedrecords.jl")

include("individual.jl")
include("individual_data.jl")

include("family.jl")

include("event.jl")
include("place.jl")
include("source.jl")

include("genealogy.jl")

include("utils.jl")
include("relations.jl")
include("nuclear.jl")

include("graphs/graphs.jl")
include("graphs/valuegraph.jl")
include("graphs/graphplots.jl")


#include("plots/makieplots.jl")

export Genealogy, genealogy_g5, individual, family
export Individual, individuals 
export FamilyUnit, families, family
export NuclearFamily, nuclearfamilies, nuclearfamily
export id, husband, wife, children
export families_asparent, family_aschild
#export Event, events
export Source, sources, source
export Location, location
export GEDRecord, gedRecords
export label
export genealogyGraph

export undocumented, singletons

end # module

