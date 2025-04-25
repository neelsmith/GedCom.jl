using GedCom
using Graphs

f = joinpath(pwd(),"test","data","pres2020.ged")
gen = genealogy_g5(f)
gengraph = genealogyGraph(gen)

##using Plots
using Graphs
using SimpleValueGraphs

vlist = vertices(gengraph) |> collect

nameidx = map(vlist) do i
    (v = i, name = get_vertexval(gengraph, i, :name))
end


using CairoMakie
using GraphMakie
GraphMakie.graphplot(gengraph)

using SimpleValueGraphs
get_vertexval(gengraph, 1200, :name)

ValMatrix(gengraph, :name, 1200)

get_vertexval(gengraph, 6, :)