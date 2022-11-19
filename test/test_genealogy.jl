
@testset "Test parsing Genealogy object and lookup by id" begin
    gen = genealogy(presfile)
    @test isa(gen, Genealogy)

    abe = GedCom.individual("@I317@", gen)
    @test isa(abe, Individual)
    @test abe.id == "@I317@"

    fam = GedCom.familyunit("@F173@", gen)
    @test isa(fam, FamilyUnit)
    @test fam.xrefId == "@F173@"
end


    