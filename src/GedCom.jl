module GedCom

import Base: ==
using Graphs
using SimpleValueGraphs

include("gedrecords.jl")
include("utils.jl")

include("individual.jl")
include("individual_data.jl")

include("family.jl")

include("event.jl")
include("place.jl")
include("source.jl")

include("genealogy.jl")

include("family_utils.jl")
include("relations.jl")
include("nuclear.jl")

#include("graphs.jl")
include("valuegraph.jl")
include("graphplots.jl")

export Genealogy, genealogy
export Individual, individuals 
export FamilyUnit, families
export NuclearFamily, nuclearfamily
#export Event, events
export Source, sources
export Location, location
export GEDRecord, gedRecords
export label
export genealogyGraph
#export GenealogyGraph, genealogyGraph

end # module

