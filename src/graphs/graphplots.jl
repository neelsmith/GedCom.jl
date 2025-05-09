
"""Supported flow directions for mermaid trees."""
mermaid_flows = [
    "TB", "BT", "RL", "LR"
]


"""Recursively add to a Vector of lines with Mermaid
diagram data starting from individual `indi`.
For an ancestor tree, we plot directly from child -> parent (no intermediate family unit).
"""
function ancestors_mermaid(indi::Individual, g::Genealogy, lines)
    indiid = replace(indi.personid, "@" => "")
    rents = parents(indi,g)
    if isnothing(rents[:father])
    else
        dadid = replace(rents[:father].personid, "@" => "")
        push!(lines, string(indiid, "(\"", mermaid_tidy(label(indi)), "\") --> ", dadid, "(\"", mermaid_tidy(label(rents[:father])), "\")"))
        ancestors_mermaid(rents[:father], g, lines)
    end
    if isnothing(rents[:mother])
    else
        momid = replace(rents[:mother].personid, "@" => "")
        push!(lines, string(indiid, "(\"", mermaid_tidy(label(indi)), "\") --> ", momid, "(\"", mermaid_tidy(label(rents[:mother])), "\")"))
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


"""Find spouse of `indi` in family group `f`."""
function spouse(indi::Individual, f::NuclearFamily)
    @debug("Nuclear fam: ", f.personid)
    if isnothing(f.husband) || isnothing(f.wife)
        @debug("No spouse")
        nothing
    else
        f.husband.personid == indi.personid ? f.wife : f.husband
    end
end

"""Recursively add to a Vector of lines with Mermaid
diagram data starting from individual `indi`.
For a descendant tree, wef plot from spouse -> family unit -> child.
"""
function descendants_mermaid_lines(indi::Individual, g::Genealogy, lines = [])
    indiid = replace(indi.personid, "@" => "")
    for familygroup in nuclearfamilies(indi,g)
        famid = replace(familygroup.personid, "@" => "")

        push!(lines, string(indiid,"(\" ", mermaid_tidy(label(indi)), "\") --> ", famid, "( )"))


        family_spouse = spouse(indi,familygroup)    
        if isnothing(family_spouse)
        else
            spouseid = replace(family_spouse.personid, "@" => "")
            push!(lines, string(spouseid,"(\" ", mermaid_tidy(label(family_spouse)), "\") --> ", famid, "( )"))
        end
        
        for kid in familygroup.children
           kidid = replace(kid.personid, "@" => "")
           push!(lines, string(famid, "( ) --> ", kidid, "(\" ", mermaid_tidy(label(kid)), "\")" ))
           descendants_mermaid_lines(kid, g, lines)
        end
        
    end
    join(lines, "\n")
end


"""Strip forbidden characters from mermaid text labels."""
function mermaid_tidy(s)
    replace(s, "\"" => "#quot;")
end