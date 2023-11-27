
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

    mermlines = descendants_mermaid(indi, g, [])
    merm = "graph $(graph_flow)\n" * mermlines
    #@info(merm)
    merm
end

function descendants_mermaid(indi::Individual, g::Genealogy, lines = [])
    indiid = replace(indi.id, "@" => "")
    kidgroups = children(indi, g)
    # Find spouse for this indi...

  
    for familykey in family_ids_spouse(indi)
        famid = replace(familykey, "@" => "")
        push!(lines, string(indiid,"(\" ", label(indi), "\") --> ", famid, "( )"))
        
        for kid in kidgroups[familykey]
            kidid = replace(kid.id, "@" => "")
            push!(lines, string(famid, "( ) --> ", kidid, "(\" ", label(kid), "\")" ))
        end
        
    end
    
    join(lines, "\n")

end
    #=

"""Recursively add to a Vector of lines with Mermaid
diagram data starting from individual `indi`.
"""
function ancestors_mermaid(indi::Individual, g::Genealogy, lines)
    #famid = if parentage(indi, g) == "Unrecorded"
    famid = if isempty(family_ids_spouse(indi))
        replace(indi.id, "@" => "") * "_NO_FAMS"
    else
        replace(family_ids_spouse(indi)[1], "@" => "")
    end
    indiid = replace(indi.id, "@" => "")

    #renparnts = parents(indi,g)
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

    =#
