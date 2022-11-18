```@setup fams
using GedCom
root = pwd() |> dirname |> dirname
f = joinpath(root, "test", "data", "pres2020.ged")
fams = families(f)
lincolnfamily = filter(f -> f.xrefId == "@F174@", fams)[1]
```

# Families

## The `FamilyUnit`

`Individual`s and `FamilyUnit`s associate an identifier with its related block of `GEDRecord`s.  Data in the associated records are accessible from a bunch of functions.


```@example fams
GedCom.husbandid(lincolnfamily)
```
```@example fams
GedCom.wifeid(lincolnfamily)
```
```@example fams
GedCom.childrenids(lincolnfamily)
```
```@example fams
GedCom.marriagedate(lincolnfamily)
```
```@example fams
GedCom.marriageplace(lincolnfamily)
```
```@example fams
GedCom.marriagelonlat(lincolnfamily)
```


## The `NuclearFamily`

The `NuclearFamily` groups together a husband, wife and list of children, each of which is an `Individual`.


parents
parentage
ancestors_mermaid
nuclearfamily
label

Walking the family tree