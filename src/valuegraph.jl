
"""Find index of ID value in a Vector of named tuples
with ID value refered to as `:id`.
"""
function idindex(id, people)
    findfirst(p -> p[:id] == id, people)
end

function genealogyGraph(gen::Genealogy)
    folks = map(gen.individuals) do i
        (id = i.id, name = label(i))
    end
    g = ValGraph(length(folks);
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

#=
"""
swissmetro_graph()

A small example graph for using in documentation.

Swissmetro was a planned (but never realised) Hyperloop style project in Switzerland.
All data was taken from Wikipedia: https://en.wikipedia.org/wiki/Swissmetro
"""
function swissmetro_graph()

cities = [
    (name = "Basel", population = 117_595),
    (name = "Bern", population = 133_791),
    (name = "Genève", population = 201_818),
    (name = "Lausanne", population = 139_111),
    (name = "St. Gallen", population = 75_833),
    (name = "Zürich", population = 415_215),
]



g = ValGraph{Int8}(
    6;
    vertexval_types=(name = String, population = Int32),
    vertexval_init=v -> cities[v],
    edgeval_types=(distance=Float64,)
)

add_edge!(g, 1, 6, (distance=89.0,))
add_edge!(g, 2, 4, (distance=81.0,))
add_edge!(g, 2, 6, (distance=104.0,))
add_edge!(g, 3, 4, (distance=68.0,))
add_edge!(g, 5, 6, (distance=69.0,))

return g
end
=#

