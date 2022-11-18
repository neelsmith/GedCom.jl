```@setup gen
root = pwd() |> dirname |> dirname
f = joinpath(root, "test", "data", "pres2020.ged")
using GedCom
gen = genealogy(f)
fam = filter(f -> f.xrefId == "@F174@", gen.families)[1]
lincoln = filter(i -> i.id == "@I317@", gen.individuals)[1]
```

# Genealogies




## Families in a genealogy
```@example gen
label(fam, gen)
```
```@example gen
GedCom.parents(lincoln, gen)
```
```@example gen
GedCom.parentage(lincoln, gen)
```
```@example gen
GedCom.nuclearfamily(lincoln, gen)
```
```@example gen
GedCom.ancestors_mermaid(lincoln, gen)
```

