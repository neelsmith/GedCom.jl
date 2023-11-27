
"""Find children of `pers`. Returns a dictionary of child `Individual`s for each
family where `pers` was a parent.
"""
function children(pers::Individual, g::Genealogy)
    childgroups = Dict()
    for fam in family_ids_spouse(pers)
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
    familyid = family_id_child(i)
    individuals = parent_ids(familyid, g)
    @debug(individuals, length(individuals))
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


"""Find IDs for parents in a family unit."""
function parent_ids(familyid::S, g::Genealogy) where S <: AbstractString
    parents = filter(g.individuals) do candidate
        kidmatch = filter(candidate.records) do r
            r.code == "FAMS" && r.message == familyid
        end
        !isempty(kidmatch)
    end
end

"""Find full siblings of individual `i`."""
function siblings(i::Individual, g::Genealogy)
    nuclearfamily(i, g).children
end

function half_siblings(i::Individual, g::Genealogy)
    []
end

function childof(p1, p2, gen)::Bool
    false
end

function parentof(p1, p2, gen)::Bool
    false
end

function siblingof(p1,p2,gen)::Bool
    false
end

function half_siblingof(p1,p2,gen)::Bool
    false
end