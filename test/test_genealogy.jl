
@testset "Test parsing Genealogy object and lookup by id" begin
    gen = genealogy_g5(presfile)
    @test isa(gen, Genealogy)

    abe = individual("@I317@", gen)
    @test isa(abe, Individual)
    @test abe.personid == "@I317@"

    fam = family("@F173@", gen)
    @test isa(fam, FamilyUnit)
    @test fam.xrefId == "@F173@"


    src = source("@S2@", gen)
    @test src.sourceId == "@S2@"
end


    


