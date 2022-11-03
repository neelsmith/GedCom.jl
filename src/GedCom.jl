module GedCom

include("gedrecords.jl")
include("family.jl")

export GEDRecord, gedRecords
export FamilyUnit, Individual
end # module


#=
Codes for record types we want to process:

INDI
FAM
SOUR
REPO    

=#