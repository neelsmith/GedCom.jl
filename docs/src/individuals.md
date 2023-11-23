```@setup indis
using GedCom
root = pwd() |> dirname |> dirname
f = joinpath(root, "test", "data", "pres2020.ged")
gen = genealogy(f)
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

GEDCOM's lineage-linked grammar models the relation of individuals to two biological parents.  The `parentage` function finds the identifier ("pointer") for the family unit that an individual was born into.

```@example indis
GedCom.parentage(abe, gen)
```


The `spouses` function returns a (possibly empty) vector of all family units in which an individual appears as a "spouse."  In addition to pairs of biological parents, the GEDCOM practice also treates married couples as family units (whether or not they have biological children).

```@example indis
GedCom.spouse_families(abe)
```