# Test `NuclearFamily` type


@testset "Test working with `NuclearFamily` type" begin
    repo = pwd() |> dirname
    srcfile = joinpath(repo, "test", "data", "pres2020.ged")
    gen = genealogy_g5(srcfile)
    abe = GedCom.individual("@I317@", gen)
    abefamilies = GedCom.nuclearfamilies(abe, gen)
    @test length(abefamilies) == 1
    

end