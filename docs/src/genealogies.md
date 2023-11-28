```@setup gen
root = pwd() |> dirname |> dirname
f = joinpath(root, "test", "data", "pres2020.ged")
using GedCom
gen = genealogy_g5(f)
```

# Genealogies

A `Genealogy` object lets you look up individuals, families and sources by ID value, and find family relations among individuals. (Following pages document many things you can do with `Individual` and `FamilyUnit` objects by themselves.)


## Look up basic objects by ID values

```@example gen
lincoln = GedCom.individual("@I317@", gen)
typeof(lincoln)
```

```@example gen
fam = GedCom.familyunit("@F173@", gen)
typeof(fam)
```

```@example gen
src = GedCom.source("@S1@", gen)
typeof(src)
```