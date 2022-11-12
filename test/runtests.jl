using GedCom
using Test

presfile = joinpath(pwd(), "data", "pres2020.ged")

patricia = """0 @I127@ INDI
1 NAME Patricia /Herzing/
2 SOUR @S73@
3 PAGE Year: 1940; Census Place: St Marys, Elk, Pennsylvania; Roll: m-t0627-03499; Page: 6A; Enumeration District: 24-30
3 DATA
4 TEXT Record for Patricia Herzing
3 OBJE @M171@
3 _LINK https://search.ancestry.com/cgi-bin/sse.dll?db=2442&h=22738949&indiv=try
1 SEX F
1 RESI StreetAddress: S Michael Street; Age: 5; AttendedSchool: No; Enumerati
2 CONC onDistrict: 24-30; Income: 0; IncomeOtherSources: No; WeeksWorked: 0
2 CONC ; MaritalStatus: Single; RelationToHead: Daughter
2 DATE 1940
2 PLAC St Marys, Elk, Pennsylvania, USA
3 MAP
4 LATI N41.4278
4 LONG W78.5611
2 SOUR @S73@
3 PAGE Year: 1940; Census Place: St Marys, Elk, Pennsylvania; Roll: m-t0627-03499; Page: 6A; Enumeration District: 24-30
3 DATA
4 TEXT Record for Patricia Herzing
3 OBJE @M171@
3 _LINK https://search.ancestry.com/cgi-bin/sse.dll?db=2442&h=22738949&indiv=try
1 EVEN White
2 TYPE Race
2 SOUR @S73@
3 PAGE Year: 1940; Census Place: St Marys, Elk, Pennsylvania; Roll: m-t0627-03499; Page: 6A; Enumeration District: 24-30
3 DATA
4 TEXT Record for Patricia Herzing
3 OBJE @M171@
3 _LINK https://search.ancestry.com/cgi-bin/sse.dll?db=2442&h=22738949&indiv=try
1 FAMS @F73@
1 FAMC @F1123@"""

tjblythe = """0 @I24@ INDI
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


include("test_gedparse.jl")
include("test_sources.jl")

