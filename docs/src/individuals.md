```@setup indis
using GedCom
root = pwd() |> dirname |> dirname
f = joinpath(root, "test", "data", "pres2020.ged")
folks = individuals(f)
abe = filter(i -> i.id == "@I317@", folks)[1]
```

# Individuals

In the following examples, `abe` is an `Individual` object containing the genealogical data for Abraham Lincoln in the test data set introduced on the home page.

There are many functions for extracting different categories of information about an individual.

Exported:

```@example indis
label(abe)
```

## Basic information (Strings)
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

## Identifiers for family relations

`parentage` looks up the identifier for the family unit he was born into.

```@example indis
GedCom.parentage(abe)
```

A vector of identifiers

```@example indis
GedCom.spouses(abe)
```



## Other interrelated items

```@example indis
GedCom.birthplace(abe)
```
```@example indis
GedCom.birthlonlat(abe)
```
```@example indis
GedCom.birthlocation(abe)
```


```@example indis
GedCom.deathplace(abe)
```
```@example indis
GedCom.deathlonlat(abe)
```
```@example indis
GedCom.deathlocation(abe)
```


```@example indis
GedCom.burialplace(abe)
```
```@example indis
GedCom.buriallonlat(abe)
```
```@example indis
GedCom.buriallocation(abe)
```

## TBA ...

```@example indis
GedCom.probate(abe)
```
```@example indis
GedCom.baptism(abe)
```
```@example indis
GedCom.residence(abe)
```
```@example indis
GedCom.occupation(abe)
```

But you can easily build your own.  See the later page on datablocks.