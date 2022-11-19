```@setup gen
root = pwd() |> dirname |> dirname
f = joinpath(root, "test", "data", "pres2020.ged")
using GedCom
gen = genealogy(f)
```

# Genealogies

A `Genealogy` object lets you look up individuals, families and sources by ID value, and find family relations among indiviudals. (Later pages document many things you can do with `Individual` and `FamilyUnit` objects by themselves.)

## Look up objects by ID values

```@example gen
lincoln = GedCom.individual("@I317@", gen)
typeof(lincoln)
```

```@example gen
fam = GedCom.familyunit("@F173@", gen)
typeof(fam)
```

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
