@testset "Test parsing gedcom from file" begin
    f = joinpath(pwd(), "data", "pres2020.ged")
    folks = individuals(f)
    @test length(folks) ==  2322

    fams = families(f)
    @test length(fams) == 1115

    srcs = sources(f)
    @test length(srcs) == 91

    gen = genealogy(f)
    @test length(gen.individuals) == length(folks)
    @test length(gen.families) == length(fams)
    @test length(gen.sources) == length(srcs)
end


@testset "Test parsing gedcom from string" begin
    gedsource = """0 @I24@ INDI
1 NAME Thomas Jefferson /Blythe/
1 SEX M
1 BIRT
2 DATE 1 AUG 1829
2 PLAC Alabama, USA
3 MAP
4 LATI N32.7665
4 LONG W86.8403
1 BURI
2 PLAC Tippah, Mississippi, USA
3 MAP
4 LATI N34.7701
4 LONG W88.9083
1 REFN Clinton-16
1 DEAT
2 DATE 6 AUG 1907
2 PLAC Tippah, Mississippi, USA
3 MAP
4 LATI N34.7701
4 LONG W88.9083
1 NOTE @N6@
1 FAMS @F14@
1 FAMS @F22@
1 FAMC @F23@"""
    gedlines = split(gedsource, "\n")
end