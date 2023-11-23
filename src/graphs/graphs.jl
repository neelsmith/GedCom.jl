
"""Node-edge-node relation of two individuals in a `GeneaologyGraph`."""
struct RelationTriple
    p1 # ID string
    p2 # ID string
    relation # one of "husband", "wife", "child"
end

"""A tree of biological descent linking parents to children.
"""
struct GenealogyGraph
    nodes
    edges::Vector{RelationTriple}
end

"""Extract a `GenealogyGraph` from a `Genealogy`.
Currently includes only individuals with two known parents.
"""
function genealogyGraph(gen::Genealogy)::GenealogyGraph
    nodelist = map(i -> i.id, gen.individuals)
    edgelist = RelationTriple[]
    for f in gen.families
        h = husbandid(f)
        w = wifeid(f)
        if isempty(h) || isempty(w)
            # for now, omit from graph unless both parents found
        else
            hrelation = RelationTriple(h, w, "husband")
            push!(edgelist, hrelation)
            wrelation = RelationTriple(w, h, "wife")
            push!(edgelist, wrelation)
        end
        for c in childrenids(f)
           if isempty(h)     
           else
                push!(edgelist,RelationTriple(c, h, "child"))
           end
           if isempty(w)
           else
                push!(edgelist, RelationTriple(c, w, "child"))
           end
        end
    end
    GenealogyGraph(nodelist, edgelist)
end

function personindex(id, people)
    findfirst(p -> p == id, people)
end

function graph(gr::GenealogyGraph)
    g = DiGraph(length(gr.nodes))
    for e in gr.edges
        # findfirst
        node1 = personindex(e.p1, gr.nodes)
        node2 = personindex(e.p2, gr.nodes)
        add_edge!(g, node1, node2)
    end
    g
end

function descendant_tree_md(indi::Individual, gen::Genealogy)
    mdlines = descendant_tree_mdlines(indi, gen) 
    data = filter(ln -> !isempty(ln), mdlines)
    join(data, "\n")
end



"""Format a descendant tree as Markdown embedded lists."""
function descendant_tree_mdlines(indi::Individual, gen::Genealogy, cumulation = [], level = 0)
    indent = repeat(" ", 4)
    spacing = repeat(indent, level)
	lines = cumulation
    
    familydict = GedCom.children(indi, gen)
    @debug("Pushed $(indi.name) ($(indi.id)) with $(length(keys(familydict))) family units at level $(level)")
    push!(lines, string(spacing, "- ", indi.name))
    @debug("""Lines now $(join(lines, "++"))""")
	for famid in keys(familydict)
        @debug("Look at $(famid)")
        for kid in familydict[famid]
           descendant_tree_mdlines(kid, gen, cumulation, level + 1)
        end
	end

    @debug("""Returning lines now $(join(lines, "++"))""")
	return lines
end

function ancestor_tree_md(indi::Individual, gen::Genealogy)
    mdlines = ancestor_tree_mdlines(indi, gen) 
    data = filter(ln -> !isempty(ln), mdlines)
    join(data, "\n")
end

function ancestor_tree_mdlines(indi::Individual, gen::Genealogy, cumulation = [], level = 0)
    indent = repeat(" ", 4)
    spacing = repeat(indent, level)
	lines = cumulation
    
    rents = GedCom.parents(indi, gen)
    if ! isnothing(rents[:father])
        push!(lines, string(spacing, "- $(level + 1) father: ", rents[:father].name))
        ancestor_tree_mdlines(rents[:father], gen, cumulation, level + 1)
    end

    if ! isnothing(rents[:mother])
        push!(lines, string(spacing, "- $(level + 1) mother: ", rents[:mother].name))
        ancestor_tree_mdlines(rents[:mother], gen, cumulation, level + 1)
    end
 
	return lines
end