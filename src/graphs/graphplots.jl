
"""Supported flow directions for mermaid trees."""
mermaid_flows = [
    "TB", "BT", "RL", "LR"
]


"""Recursively add to a Vector of lines with Mermaid
diagram data starting from individual `indi`.
For an ancestor tree, we plot directly from child -> parent (no intermediate family unit).
"""
function ancestors_mermaid(indi::Individual, g::Genealogy, lines)
    indiid = replace(indi.id, "@" => "")
    rents = parents(indi,g)
    if isnothing(rents[:father])
    else
        dadid = replace(rents[:father].id, "@" => "")
        push!(lines, string(indiid, "(\"", label(indi), "\") --> ", dadid, "(\"", label(rents[:father]), "\")"))
        ancestors_mermaid(rents[:father], g, lines)
    end
    if isnothing(rents[:mother])
    else
        momid = replace(rents[:mother].id, "@" => "")
        push!(lines, string(indiid, "(\"", label(indi), "\") --> ", momid, "(\"", label(rents[:mother]), "\")"))
        ancestors_mermaid(rents[:mother], g, lines)
    end
    join(lines,"\n")
end

"""Create a Mermaid plot of an ancestor tree for individual `indi`.
Default orientation is bottom-to-top.
"""
function ancestors_mermaid(indi::Individual, g::Genealogy; flow = "BT")
    graph_flow = in(uppercase(flow), mermaid_flows) ? uppercase(flow)  : "BT"
    lines = ancestors_mermaid(indi, g, [])
   "graph $(graph_flow)\n" * lines
end


"""Create a Mermaid plot of a descendant tree for individual `indi`.
Default orientation is top-to-bottom.
"""
function descendants_mermaid(indi::Individual, g::Genealogy; flow = "TB")
    graph_flow = in(uppercase(flow), mermaid_flows) ? uppercase(flow)  : "TB"

    mermlines = descendants_mermaid_lines(indi, g, [])
    merm = "graph $(graph_flow)\n" * mermlines
    merm
end


"""Recursively add to a Vector of lines with Mermaid
diagram data starting from individual `indi`.
For a descendant tree, we plot from spouse -> family unit -> child.
"""
function descendants_mermaid_lines(indi::Individual, g::Genealogy, lines = [])
    indiid = replace(indi.id, "@" => "")
    famgroups = nuclearfamilies(indi,g)
    for familygroup in nuclearfamilies(indi,g)
        famid = replace(familygroup.id, "@" => "")

        push!(lines, string(indiid,"(\" ", label(indi), "\") --> ", famid, "( )"))

        spouseidraw = familygroup.husband.id == indi.id ? familygroup.wife.id : familygroup.husband.id
        spouse = individual(spouseidraw, g)
        spouseid = replace(spouseidraw, "@" => "")
        
        push!(lines, string(spouseid,"(\" ", label(spouse), "\") --> ", famid, "( )"))
        
        for kid in familygroup.children
           kidid = replace(kid.id, "@" => "")
           push!(lines, string(famid, "( ) --> ", kidid, "(\" ", label(kid), "\")" ))
           descendants_mermaid_lines(kid, g, lines)
        end
        
    end
    
    join(lines, "\n")

end
