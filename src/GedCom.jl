module GedCom

import Base: ==
using Graphs

include("gedrecords.jl")
include("utils.jl")
include("individual.jl")
include("individual_data.jl")
include("family.jl")
include("event.jl")
include("place.jl")
include("source.jl")
include("genealogy.jl")
include("nuclear.jl")
include("graphs.jl")

export Genealogy, genealogy
export Individual, individuals 
export FamilyUnit, families
export NuclearFamily, nuclearfamily
#export Event, events
export Source, sources
export Location, location
export GEDRecord, gedRecords
export label

export GenealogyGraph, genealogyGraph

end # module

