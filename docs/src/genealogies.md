```@setup gen
root = pwd() |> dirname |> dirname
f = joinpath(root, "test", "data", "pres2020.ged")
using GedCom
gen = genealogy(f)
fam = filter(f -> f.xrefId == "@F174@", gen.families)[1]
lincoln = filter(i -> i.id == "@I317@", gen.individuals)[1]
```

# Genealogies

Later pages document many things you can do with `Individual` and `FamilyUnit` objects by themselves. To find relations among them, you can use a `Genealogy`.



## Families in a genealogy

Label the `FamilyUnit` with the exported `label` function:

```@example gen
label(fam, gen)
```

Find parents for an individual. The result is a named tuple of `Individual`s.

```@example gen
abeparents = GedCom.parents(lincoln, gen)
abeparents[:mother]
```
```@example gen
abeparents[:father]
```


Diagram an ancestor tree for an individual in the genealogy.  The result is the text of a [Mermaid diagram](https://mermaid-js.github.io/mermaid/#/).

```@example gen
GedCom.ancestors_mermaid(lincoln, gen)
```



```@example gen
GedCom.nuclearfamily(fam, gen)
```