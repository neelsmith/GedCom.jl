
@testset "Test parsing gedcom from file" begin
    folks = individuals(presfile)
    @test length(folks) ==  2322

    fams = families(presfile)
    @test length(fams) == 1115

    srcs = sources(presfile)
    @test length(srcs) == 91

    gen = genealogy(presfile)
    @test length(gen.individuals) == length(folks)
    @test length(gen.families) == length(fams)
    @test length(gen.sources) == length(srcs)
end


@testset "Test parsing gedcom from string" begin
    gedlines = split(tjblythe, "\n")
    recc = gedRecords(gedlines)
    @test length(recc) == 25

    gen = genealogy(gedlines)
    @test length(gen.individuals) == 1
    @test length(gen.families) == 1
    @test isempty(gen.sources)
end


@testset "Test parsing data values for GEDCOM code" begin
    expected = [[GEDRecord(1, nothing, "BURI", ""),
    GEDRecord(2, nothing, "PLAC", "Tippah, Mississippi, USA"),
    GEDRecord(3, nothing, "MAP", ""),
    GEDRecord(4, nothing, "LATI", "N34.7701"),
    GEDRecord(4, nothing, "LONG", "W88.9083") ] ]

    gedlines = split(tjblythe, "\n")
    recc = gedRecords(gedlines)
    v = GedCom.blocks(recc,"BURI")
    @test length(v) == 1
    @test expected == GedCom.blocks(v[1],"BURI")
end

@testset "Test parsing continued data values with CONC" begin
    expected = "StreetAddress: S Michael Street; Age: 5; AttendedSchool: No; EnumerationDistrict: 24-30; Income: 0; IncomeOtherSources: No; WeeksWorked: 0; MaritalStatus: Single; RelationToHead: Daughter"

    gedlines = split(patricia, "\n")
    recc = gedRecords(gedlines)
    @test GedCom.data(recc,"RESI") == expected
end
