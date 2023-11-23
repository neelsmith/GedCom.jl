"""A tree of biological descent linking parents to children.
"""
struct GenealogyGraph
    nodes
    edges::Vector{RelationTriple}
end

"""Node-edge-node relation of two individuals in a `GeneaologyGraph`."""
struct RelationTriple
    p1 # ID string
    p2 # ID string
    relation # one of "husband", "wife", "child"
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