@testset "Test parsing gedcom" begin
    f = joinpath(pwd(), "data", "pres2020.ged")
    folks = individuals(f)
    @test length(folks) ==  2322
end