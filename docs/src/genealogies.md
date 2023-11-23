```@setup gen
root = pwd() |> dirname |> dirname
f = joinpath(root, "test", "data", "pres2020.ged")
using GedCom
gen = genealogy(f)
```

# Genealogies

A `Genealogy` object lets you look up individuals, families and sources by ID value, and find family relations among individuals. (Following pages document many things you can do with `Individual` and `FamilyUnit` objects by themselves.)
