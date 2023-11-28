using GedCom

f = joinpath(pwd(),"test","data","pres2020.ged")
gen = genealogy_g5(f)

gengraph = genealogyGraph(gen)

using Plots
using GraphRecipes
graphplot(gengraph)