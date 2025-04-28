using GedCom
using Graphs
using SimpleValueGraphs

f = joinpath(pwd(),"test","data","pres2020.ged")
gen = genealogy_g5(f)
gengraph = genealogyGraph(gen)

##using Plots
using Graphs
using SimpleValueGraphs

#vlist = vertices(gengraph) |> collect
# Pair up (in a named tuple) the ID and a readable label for every node in the graph:
nameidx = []
for i in vertices(gengraph)
    push!(nameidx, (v = i, 
    id = get_vertexval(gengraph, i, :id), 
    name = get_vertexval(gengraph, i, :name))
    )
end


# Learn how to use value graphs:
get_vertexval(gengraph, 1200, :name)
ValMatrix(gengraph, :name, 1200)
get_vertexval(gengraph, 6, :)

#
for n in nameidx[1:10]
    theedges = filter(e -> e.src == n.v || e.dst == n.v, edgelist)
    @info("$(length(theedges)) edges for node $(n)")
    for e in theedges
        @info("  -> $(e) wtihe edegval $(get_edgeval(gengraph, e.src, e.dst))")
    end
end









# Plotting with defaults
using CairoMakie
using GraphMakie
GraphMakie.graphplot(gengraph)
