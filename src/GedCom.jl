module GedCom

import Base: ==


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

export Genealogy, genealogy
export Individual, individuals 
export FamilyUnit, families
export NuclearFamily, nuclearfamily
#export Event, events
export Source, sources
export GEDRecord, gedRecords
export label

end # module

