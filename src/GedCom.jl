module GedCom

include("gedrecords.jl")
include("individual.jl")
include("family.jl")
include("event.jl")
include("place.jl")
include("source.jl")
include("genealogy.jl")

export Genealogy, genealogy
export Individual, individuals, label
export FamilyUnit, families
#export Event, events
#export Source, sources
export GEDRecord


end # module


#=
Codes for main record types we want to process:

√ INDI
√ FAM
SOUR
REPO    

also events and places
=#