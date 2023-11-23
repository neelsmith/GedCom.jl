
"""Find children of `pers`. Returns a dictionary of child `Individual`s for each
family where `pers` was a parent.
"""
function children(pers::Individual, g::Genealogy)
    childgroups = Dict()
    for fam in spouse_families(pers)
        familykids = filter(g.individuals) do ind
            GedCom.data(ind.records, "FAMC") == fam
        end
        childgroups[fam] = familykids
    end
    childgroups
end


"""Construct a dictionary of child `Individual`s for each
family where one parent was identified with ID `persID`.
"""
function children(persID::T, g::Genealogy) where T <: AbstractString
    children(individual(persID, g), g)
end


"""Construct a named tuple with mother and father for
an `Individual`.  Tuple subelement is `nothing` if mother 
or father is missing.
"""
function parents(i::Individual, g::Genealogy)
    individuals = parent_ids(i)
    @debug(individuals)
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
    familyid = parentage(i, gen)
    @debug("Parent family of $(label(i)) is $(familyid)")

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



function siblings()
    []
end

function parentof()::Bool
    false
end

function siblingof()::Bool
    false
end