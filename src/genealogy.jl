struct Genealogy
    individuals::Vector{Individual}
    families::Vector{FamilyUnit}
    #events::Vector{Event}
    #sources::Vector{Source}
end

"""Build a `Genealogy`` from a GECOM file source.
"""
function genealogy(f)
    folks = individuals(f)
    fams = families(f)
    Genealogy(folks, fams)
end






"""Collect `Individual` objects for each member of a nuclear family.
Return a triple with husband, wife and children.
"""
function nuclearfamily(fam::FamilyUnit, gen::Genealogy )
    # husband: 
    hmatches = filter(i -> i.id == husbandid(fam), gen.individuals)
    h = isempty(hmatches) ? nothing : hmatches[1]
    wmatches = filter(i -> i.id == wifeid(fam), gen.individuals)
    w = isempty(wmatches) ? nothing : wmatches[1]
    kids = map(childrenids(fam)) do kid
        filter(i -> i.id == kid, gen.individuals)[1]
    end
    NuclearFamily(h, w, kids)
end


#"""Construct a (possibly empty) Vector of child `Individual`s for `i`.
#"""
#=
we need a structure that has spouse + children: the `FamilyUnit`

function children(p1::Individual, g::Genealogy)
    spouselist = spouses(p1)
    
    for sp in spouselist
        husband = GedCom.sex(p1) == "M" ? p1 : sp
        wife = GedCom.sex(p1) == "F" ? p1 : sp


    end
    =#
#=
    children = filter(g.individuals) do kid
        filter(candidate.records) do r
            r.code == "FAMC" && r.message == familyid
        end
        !isempty(kidmatch)
    end
    children
   
end
 =#

"""Construct a named tuple with mother and father for
an `Individual`.  Tuple subelement is `nothing` if mother 
or father is missing.
"""
function parents(i::Individual, g::Genealogy)
    individuals = parentage(i,g)
    @info(individuals)
    if length(individuals) == 2
        if sex(individuals[1]) == "M"
            (father = individuals[1], mother = individuals[2])
        else
            (father = individuals[2], mother = individuals[1])
        end
    elseif length(individuals) == 1
        if sex(individuals[1]) == "M"
            (father = individuals[1], mother = nothing)
        else
            (father = nothing, mother = individuals[1])
        end
    else
        (father = nothing, mother = nothing)
    end
end

"""Look for individuals in a `Genealogy` identified
as parents of `i`.
"""
function parentage(i::Individual, g::Genealogy)
    familyid = parentage(i)
    @info("Parent family of $(label(i)) is $(familyid)")

    if familyid == "Unrecorded"
        []
    else
        parents = filter(g.individuals) do candidate
            kidmatch = filter(candidate.records) do r
                r.code == "FAMS" && r.message == familyid
            end
            !isempty(kidmatch)
        end
        parents 
    end
end