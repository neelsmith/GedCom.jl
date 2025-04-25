using GedCom
using Graphs
using SimpleValueGraphs

f = joinpath(pwd(),"test","data","pres2020.ged")
gen = genealogy_g5(f)
gengraph = genealogyGraph(gen)

##using Plots
using Graphs
using SimpleValueGraphs

vlist = vertices(gengraph) |> collect

# Pair up in a named tuple the ID and a readable label for 
# every node in the graph:
nameidx = map(vlist) do i
    (v = i, name = get_vertexval(gengraph, i, :name))
end


# Learn how to use value graphs:
get_vertexval(gengraph, 1200, :name)
ValMatrix(gengraph, :name, 1200)
get_vertexval(gengraph, 6, :)



# Plotting with defaults
using CairoMakie
using GraphMakie
GraphMakie.graphplot(gengraph)
