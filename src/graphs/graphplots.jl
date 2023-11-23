
"""Recursively add to a Vector of lines with Mermaid
diagram data starting from individual `indi`.
"""
function ancestors_mermaid(indi::Individual, g::Genealogy, lines)
    famid = if parentage(indi, g) == "Unrecorded"
        replace(indi.id, "@" => "") * "_NO_FAMC"
    else
        replace(parentage(indi, g), "@" => "")
    end
    indiid = replace(indi.id, "@" => "")
    #renparnts = parents(indi,g)
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


"""Create a Mermaid plot of an ancestor tree ofr individual `indi`."""
function ancestors_mermaid(indi::Individual, g::Genealogy)
    lines = ancestors_mermaid(indi, g, [])
   "graph TD\n" * lines
end