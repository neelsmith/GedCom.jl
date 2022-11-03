module GedCom

include("gedrecords.jl")
include("family.jl")
include("individual.jl")

export Genealogy, genealogy
export Individual, individuals, label
export FamilyUnit, families
export GEDRecord


end # module


#=
Codes for record types we want to process:

INDI
FAM
SOUR
REPO    

=#