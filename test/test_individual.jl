birchie = """
0 @I10@ INDI
1 NAME Lou Birchie /Ayers/
2 SOUR @S1@
3 DATA
4 TEXT Record for Simpson Green Ayers
3 _LINK https://search.ancestry.com/cgi-bin/sse.dll?db=60525&h=105157744&indiv=try
1 SEX F
1 BIRT
2 DATE 9 FEB 1893
2 PLAC Tippah, Mississippi, USA
3 MAP
4 LATI N34.7701
4 LONG W88.9083
2 SOUR @S1@
3 DATA
4 TEXT Record for Simpson Green Ayers
3 _LINK https://search.ancestry.com/cgi-bin/sse.dll?db=60525&h=105157744&indiv=try
1 BURI West Hill Cem,
2 PLAC Sherman, Grayson, Texas, USA
3 MAP
4 LATI N33.6357
4 LONG W96.6089
2 SOUR @S1@
3 DATA
4 TEXT Record for Simpson Green Ayers
3 _LINK https://search.ancestry.com/cgi-bin/sse.dll?db=60525&h=105157744&indiv=try
1 REFN Clinton-5
1 DEAT
2 DATE 15 FEB 1946
2 PLAC Sherman, Grayson, Texas, USA
3 MAP
4 LATI N33.6357
4 LONG W96.6089
2 SOUR @S1@
3 DATA
4 TEXT Record for Simpson Green Ayers
3 _LINK https://search.ancestry.com/cgi-bin/sse.dll?db=60525&h=105157744&indiv=try
1 FAMS @F4@
1 FAMC @F11@
"""


@testset "Test parsing `Individual` type" begin
    folks = individuals(presfile)
    @test length(folks) == 2322


    ayers = individuals(split(birchie,"\n"))[1]
    @test ayers.id == "@I10@"
end