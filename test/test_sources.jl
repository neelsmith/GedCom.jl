s3 = """0 @S3@ SOUR
1 AUTH Historical Data Systems, comp.
1 TITL American Civil War General Officers
1 PUBL Name: Ancestry.com Operations Inc; Location: Provo, UT, USA; Date: 199
2 CONC 9;
1 REPO @R1@
1 NOTE
2 CONC Data compiled by Historical Data Systems of Kingston, MA from the <a h
2 CONC ref="##AncestryUrlPrefix##/handler/domainrd.ashx?domain=AncestryDomain
2 CONC &url=/search/rectype/military/cwrd/db.htm">following list of works</a>
2 CONC . Copyright 1997-2000. Historical Data Systems, Inc.<br>  PO Box 35<br
2 CONC >  Duxbury, MA 02331."""

@testset "Test parsing `Source` type" begin
    srcs = sources(presfile)
    @test length(srcs) == 91

    src3 = sources(split(s3,"\n"))[1]
    @test GedCom.title(src3) == "American Civil War General Officers"
    @test GedCom.author(src3) == "Historical Data Systems, comp."
    @test GedCom.publication(src3) == "Name: Ancestry.com Operations Inc; Location: Provo, UT, USA; Date: 1999;Data compiled by Historical Data Systems of Kingston, MA from the <a href=\"##AncestryUrlPrefix##/handler/domainrd.ashx?domain=AncestryDomain&url=/search/rectype/military/cwrd/db.htm\">following list of works</a>. Copyright 1997-2000. Historical Data Systems, Inc.<br>  PO Box 35<br>  Duxbury, MA 02331."
    @test GedCom.data(src3.records, "REPO") == "@R1@"
   
end