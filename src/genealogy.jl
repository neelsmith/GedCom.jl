"""A `Genealogy` is composed of individuals, related in families,
and documented by source statements.
"""
struct Genealogy
    individuals::Vector{Individual}
    families::Vector{FamilyUnit}
    sources::Vector{Source}
end

"""Build a `Genealogy` from a GEDCOM file source.
"""
function genealogy(f)
    folks = individuals(f)
    fams = families(f)
    srcs = sources(f)
    Genealogy(folks, fams, srcs)
end

"""Build a `Genealogy`from a string of GEDCOM data.
"""
function fromgedcom(s)
    grecords = gedRecords(f)

    Genealogy(parseIndividuals(grecords), parseFamilies(grecords), parseSources(grecords))
end



"""Look up an individual in a genealogy by ID.
Returns an `Individual` or `nothing`.
"""
function individual(id::S, gen::Genealogy )::Union{Individual, Nothing} where S <: AbstractString
    matches = filter(i -> i.id == id, gen.individuals)
    length(matches) == 1 ? matches[1] : nothing  
end


"""Look up a family unit in a genealogy by ID.
Returns an `FamilyUnit` or `nothing`.
"""
function familyunit(id::S, gen::Genealogy)::Union{FamilyUnit, Nothing} where S <: AbstractString
    matches = filter(f -> f.xrefId == id, gen.families)
    length(matches) == 1 ? matches[1] : nothing  
end


"""Collect `Individual` objects for each member of the nuclear family
idenfied by `id`. Return a triple with `Individual` husband, `Individual` wife and Vector of `Individual` children.
"""
function nuclearfamily(id::S, gen::Genealogy)  where S <: AbstractString
    nuclearfamily(familyunit(id,gen), gen)
end

"""Collect `Individual` objects for each member of a nuclear family.
Return a triple with `Individual` husband, `Individual` wife and Vector of `Individual` children.
"""
function nuclearfamily(fam::FamilyUnit, gen::Genealogy)
    # husband: 
    hmatches = filter(i -> i.id == husbandid(fam), gen.individuals)
    h = isempty(hmatches) ? nothing : hmatches[1]
    wmatches = filter(i -> i.id == wifeid(fam), gen.individuals)
    w = isempty(wmatches) ? nothing : wmatches[1]
    kids = map(childrenids(fam)) do kid
        filter(i -> i.id == kid, gen.individuals)[1]
    end
    NuclearFamily(fam.xrefId, h, w, kids)
end

"""Compose a label for a `FamilyUnit`.
"""
function label(fam::FamilyUnit, gen::Genealogy)
    nuclearfamily(fam, gen ) |> label
end

"""Construct a dictionary of child `Individual`s for each
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
    familyid = parentage(i)
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



"""Recursively add to a Vector of lines with Mermaid
diagram data starting from individual `indi`.
"""
function ancestors_mermaid(indi::Individual, g::Genealogy, lines)
    famid = if parentage(indi) == "Unrecorded"
        replace(indi.id, "@" => "") * "_NO_FAMC"
    else
        replace(parentage(indi), "@" => "")
    end
    indiid = replace(indi.id, "@" => "")
    rents = parents(indi,g)
    push!(lines, string(indiid, "(\"", label(indi), "\") --> ", famid, "( )"))
    if isnothing(rents[:father])
    else
        dadid = replace(rents[:father].id, "@" => "")
        push!(lines, string(famid, " --> ", dadid, "(\"", label(rents[:father]), "\")"))
        ancestors_mermaid(rents[:father], g, lines)
    end
    if isnothing(rents[:mother])
    else
        momid = replace(rents[:mother].id, "@" => "")
        push!(lines, string(famid, " --> ", momid, "(\"", label(rents[:mother]), "\")"))
        ancestors_mermaid(rents[:mother], g, lines)
    end


    join(lines,"\n")
end

function ancestors_mermaid(indi::Individual, g::Genealogy)
    lines = ancestors_mermaid(indi::Individual, g::Genealogy, [])
   "graph TD\n" * lines
   
end
