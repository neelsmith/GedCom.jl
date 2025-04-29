# Test `NuclearFamily` type


@testset "Test working with `NuclearFamily` type" begin
    repo = pwd() |> dirname
    srcfile = joinpath(repo, "test", "data", "pres2020.ged")
    gen = genealogy_g5(srcfile)

    fams = nuclearfamilies(gen)
    @test length(fams) == 1115


    abe = individual("@I317@", gen)
    abefamilies = nuclearfamilies(abe, gen)
    @test length(abefamilies) == 1
    abefam = abefamilies[1]

    derivedfam  = nuclearfamily(id(abefam), gen)
    @test derivedfam == abefam
    

end