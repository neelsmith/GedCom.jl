```@setup indis
using GedCom
root = pwd() |> dirname |> dirname
f = joinpath(root, "test", "data", "pres2020.ged")
gen = genealogy_g5(f)
abe = GedCom.individual("@I317@", gen)
```

# Individuals

Most of the data in a GEDCOM source is organized in the records for an individual.  In the following examples, `abe` is an `Individual` object containing the genealogical data for Abraham Lincoln in the test data set of presidential genealogies. The entire presidential genealogy is read into an variable named `gen`.


## Basic information (String values)

`GedCom.jl` includes many functions for extracting different categories of information about an individual as string values.

The `label` function is exported:

```@example indis
label(abe)
```

Other functions must be qualified with the package name.


```@example indis
GedCom.lastname(abe)
```
```@example indis
GedCom.dateslabel(abe)
```
```@example indis
GedCom.sex(abe)
```
```@example indis
GedCom.deathdate(abe)
```
```@example indis
GedCom.birthdate(abe)
```



## Family relations

GEDCOM's lineage-linked grammar models the relation of individuals to two biological parents.  



### Family IDs

From a single `Individual` object, you can find family identifiers for families an individual belongs to as a child or as a spouse.


```@example indis
GedCom.family_id_child(abe)
```


```@example indis
GedCom.family_ids_spouse(abe)
```

### Structures with `Individual`s

Other functions let you find fully instantiated `Individual` objects for a person in a genealogy. `GedCom.parents` returns a named tuple:

```@example indis
abe_parents = GedCom.parents(abe, gen)
abe_parents[:father]
```
```@example indis
abe_parents[:mother]
```


`GedCom.siblings` returns a list:

```@example indis
sibs = GedCom.siblings(abe, gen)
```


