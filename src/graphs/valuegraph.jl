
"""Find index of ID value in a Vector of named tuples
with ID value refered to as `:id`.
"""
function idindex(id, people)
    findfirst(p -> p[:id] == id, people)
end

"""Create a directed value graph for `gen`.
Nodes have the ID and label for individuals,
edges have a string with one of three relationship types:
"husband", "wife" or "child".
"""
function genealogyGraph(gen::Genealogy)
    folks = map(gen.individuals) do i
        (id = i.id, name = label(i))
    end
    g = ValDiGraph(length(folks);
    vertexval_types=(id = String, name = String),
    vertexval_init=v -> folks[v],
    edgeval_types=(relation=String,)
    )

    #=
    Find indices in vector of 2 individuals.
    compute relation type for edge value.
    =#

    for f in gen.families
        h = husbandid(f)
        w = wifeid(f)
        h_index = 0
        w_index = 0
     
        if isempty(h) || isempty(w)
        else
            h_index = idindex(h, folks)
            w_index = idindex(w, folks)
            add_edge!(g, h_index, w_index, (relation="Husband",))   
            add_edge!(g, w_index, h_index, (relation="Wife",))     
        end
        
        for c in childrenids(f)
            c_index = idindex(c, folks)
           if isempty(h)     
           else
            add_edge!(g, c_index, h_index, (relation="Child",)) 
           end
           if isempty(w)
           else
            add_edge!(g, c_index, w_index, (relation="Child",))
           end
        end
        
    end
    g
end





"""Find list of unique values for edges in a graph.
$(SIGNATURES)
"""
function edgevals(gr::ValDiGraph)
    vallist = []
    for e in edges(gr)
       edgval = get_edgeval(gr, e.src, e.dst)
       push!(vallist, edgval)
    end
    unique(vallist)
end


"""Find all `ValDiEdge`s in graph for a given node `n`
$(SIGNATURES)
"""
function edgesfornode(gr::ValDiGraph, n)
    edgesfornode(collect(edges(gr)), n)
end


"""Find all edges in a list of edges including a given node `n`
$(SIGNATURES)
"""
function edgesfornode(elist, n)
    filter(elist) do e
        e.src == n || e.dst == n
    end
end

"""Find all individuals in a graph with no connections.
$(SIGNATURES)
"""
function singletons(gr::ValDiGraph) 
    edgelist = collect(edges(gr))
    filter(individualindex(gr)) do indi
        isempty(edgesfornode(edgelist, indi.v))
    end
end

#=
function singletons(gr::ValDiGraph, gen::Genealogy)

   map(singletons(gr)) do id
   end
end
=#


function individualindex(gr::ValDiGraph)
    nameidx = []
    for i in vertices(gr)
        push!(nameidx, (v = i, 
        id = get_vertexval(gr, i, :id), 
        name = get_vertexval(gr, i, :name))
        )
    end
    nameidx
end
