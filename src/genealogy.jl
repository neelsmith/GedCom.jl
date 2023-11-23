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
