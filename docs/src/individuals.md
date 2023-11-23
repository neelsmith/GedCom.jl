```@setup indis
using GedCom
root = pwd() |> dirname |> dirname
f = joinpath(root, "test", "data", "pres2020.ged")
gen = genealogy(f)
abe = GedCom.individual("@I317@", gen)
```

# Individuals