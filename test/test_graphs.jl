using SimpleValueGraphs
using Graphs

@testset "Test types of graph structure from Genealogy object" begin
    gen = genealogy_g5(presfile)
    gr = genealogyGraph(gen) 

    @test supertype(typeof(gr)) ==  SimpleValueGraphs.AbstractValGraph{Int32, NamedTuple{(:id, :name), Tuple{String, String}}, NamedTuple{(:relation,), Tuple{String}}, Tuple{}}

    @test eltype(gr) == Int32
    @test vertexvals_type(gr) ==     NamedTuple{(:id, :name), Tuple{String, String}}
    @test edgevals_type(gr) ==  NamedTuple{(:relation,), Tuple{String}}

    
end

@testset "Test graph topology" begin
    gen = genealogy_g5(presfile)
    gr = genealogyGraph(gen) 
    
    @test is_directed(gr) 
    @test has_self_loops(gr) == false
end


@testset "Test working with verticies of graph from Genealogy object" begin
    gen = genealogy_g5(presfile)
    gr = genealogyGraph(gen)
    
    @test nv(gr) == 2322
    @test length(collect(vertices(gr))) == nv(gr)

    @test has_vertex(gr, 3000) == false
    @test has_vertex(gr, 25)
    @test get_vertexval(gr, 25, :) == (id = "@I24@", name = "Thomas Jefferson Blythe (1829-1907)")
    get_vertexval(gr, 25, :name) ==  "Thomas Jefferson Blythe (1829-1907)"
    @test inneighbors(gr, 25) == [16, 26, 27]
    @test outneighbors(gr, 25) == [26, 27, 42, 43]
    @test all_neighbors(gr, 25) == [26, 27, 42, 43, 16]
end

@testset "Test working with edges of graph from Genealogy object" begin
    gr = genealogy_g5(presfile) |> genealogyGraph
    @test ne(gr) == 4470
    @test length(collect(edges(gr))) == ne(gr)

    @test has_edge(gr, 25, 24) == false


    @test get_vertexval(gr, 25, :name) == "Thomas Jefferson Blythe (1829-1907)"
    @test get_vertexval(gr, 26, :name) == "Esther Elvira Baum (1825-1865)"
    @test has_edge(gr, 25, 26)
    @test get_edgeval(gr, 25, 26, :relation) == "Husband"
    @test has_edge(gr, 26, 25)
    @test get_edgeval(gr, 26, 25, :relation) == "Wife"
    
    @test get_vertexval(gr, 42, :name) == "Andrew Jackson Blythe Sr (1801-1851)"
    @test get_edgeval(gr, 25, 42, :relation) == "Child"

    @test inedgevals(gr, 25) == ["Child", "Wife", "Wife"]
    outedgevals(gr, 25) == ["Husband", "Husband", "Child", "Child"]

    @test inedgevals(gr, 26) == ["Child",  "Husband"]
    @test outedgevals(gr, 26) == ["Wife", "Child", "Child"]

end