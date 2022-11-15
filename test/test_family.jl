famstring = """0 @F6@ FAM
1 HUSB @I6@
1 WIFE @I4@
1 MARR
2 DATE 7 OCT 1950
2 PLAC Buffalo, Erie, New York, USA
3 MAP
4 LATI N42.8864
4 LONG W78.8784
2 SOUR @S22@
3 PAGE New York State Department of Health; Albany, NY, USA; New York State Marriage Index
3 DATA
4 TEXT Record for Donald Clark
3 OBJE @M11@
3 _LINK https://search.ancestry.com/cgi-bin/sse.dll?db=61632&h=1558842&indiv=try"""

@testset "Test parsing `FamilyUnit` type" begin
    famm = families(presfile)
    @test length(famm) == 1115

    fam6 = families(split(famstring,"\n"))[1]

    @test GedCom.husbandid(fam6) == "@I6@"
    @test GedCom.wifeid(fam6) ==  "@I4@"
    @test isempty(GedCom.childrenids(fam6))
    @test GedCom.marriagelonlat(fam6)  == (lon = "W78.8784", lat = "N42.8864")
    @test GedCom.marriagedate(fam6) == "7 OCT 1950"
    @test GedCom.marriageplace(fam6) == "Buffalo, Erie, New York, USA"
    mrglonlats = filter(famm) do fml
        ! isnothing(GedCom.marriagelonlat(fml))
    end
    @test length(mrglonlats) == 232
end    