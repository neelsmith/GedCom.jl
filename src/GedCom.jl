module GedCom

include("gedrecords.jl")
include("genealogy.jl")
include("family.jl")
include("individual.jl")
include("event.jl")
include("place.jl")
include("source.jl")

export Genealogy, genealogy
export Individual, individuals, label
export FamilyUnit, families
#export Event, events
#export Source, sources
export GEDRecord


end # module


#=
Codes for record types we want to process:

INDI
FAM
SOUR
REPO    

=#