using GedCom

f = joinpath(pwd(),"test","data","pres2020.ged")
gen = genealogy(f)

gengraph = genealogyGraph(gen)

using Plots
using GraphRecipes
graphplot(gengraph)