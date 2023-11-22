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
function individual(id::S, gen::Genealogy ) where S <: AbstractString
    matches = filter(i -> i.id == id, gen.individuals)
    length(matches) == 1 ? matches[1] : nothing  
end


"""Look up a family unit in a genealogy by ID.
Returns an `FamilyUnit` or `nothing`.
"""
function familyunit(id::S, gen::Genealogy ) where S <: AbstractString
    matches = filter(f -> f.xrefId == id, gen.families)
    length(matches) == 1 ? matches[1] : nothing  
end


"""Collect `Individual` objects for each member of a nuclear family.
Return a triple with `Individual` husband, `Individual` wife and Vector of `Individual`s children.

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
    NuclearFamily(fam.xrefId, h, w, kids)
end


function label(fam::FamilyUnit, gen::Genealogy)
    nuclearfamily(fam, gen ) |> label
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
