```@setup gen
root = pwd() |> dirname |> dirname
f = joinpath(root, "test", "data", "pres2020.ged")
using GedCom
gen = genealogy(f)
fam = filter(f -> f.xrefId == "@F174@", gen.families)[1]
lincoln = filter(i -> i.id == "@I317@", gen.individuals)[1]
```

# Genealogies

A `Genealogy` object lets you find family relations among indiviudals. (Later pages document many things you can do with `Individual` and `FamilyUnit` objects by themselves.)



## Relations



Find parents for an individual. The result is a named tuple of `Individual`s.

```@example gen
abeparents = GedCom.parents(lincoln, gen)
abeparents[:mother]
```
```@example gen
abeparents[:father]
```


Use the exported `label` function to label a `FamilyUnit` with names of both spouses:

```@example gen
label(fam, gen)
```


The `FamilyUnit` stays close to the GEDCOM structure: its most crucial information is just a series of pointers to individuals in roles of spouse or children.  `GedCom.jl` also includes a `NuclearFamily` type where those pointers are replaced with fully instantiated `Individual`s.

```@example gen
nuke = GedCom.nuclearfamily(fam, gen)
typeof(nuke)
```

```@example gen
label(nuke.husband)
```


```@example gen
label(nuke.wife)
```

```@example gen
length(nuke.children)
```
## Charts


Diagram an ancestor tree for an individual in the genealogy.  The result is the text of a [Mermaid diagram](https://mermaid-js.github.io/mermaid/#/).


```@example gen
GedCom.ancestors_mermaid(lincoln, gen)
```
