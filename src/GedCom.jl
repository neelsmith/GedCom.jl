module GedCom

include("gedrecords.jl")
include("family.jl")
include("individual.jl")

export GEDRecord
export FamilyUnit, families
export Individual, individuals

end # module


#=
Codes for record types we want to process:

INDI
FAM
SOUR
REPO    

=#