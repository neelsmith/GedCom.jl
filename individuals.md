

## Identifiers for family relations

GEDCOM's lineage-linked grammar models the relation of individuals to two biological parents.  The `parentage` function finds the identifier ("pointer") for the family unit that an individual was born into.

```@example indis
GedCom.parentage(abe)
```


The `spouses` function returns a (possibly empty) vector of all family units in which an individual appears as a "spouse."  In addition to pairs of biological parents, the GEDCOM practice also treates married couples as family units (whether or not they have biological children).

```@example indis
GedCom.spouse_families(abe)
```

> **TBA**: `children(abe)`

## Locations

For the birth, death and burial of an individual, `GedCom.jl` has parallel groups of functions for finding a place name, a pair of longitude-latitude coordinates or a `Location` object which groups place name and coordinates together.

The `[X]place` functions return a String value.

```@example indis
GedCom.birthplace(abe)
```
```@example indis
GedCom.deathplace(abe)
```
```@example indis
GedCom.burialplace(abe)
```

The `[X]lonlat` functions return either a named tuple or `nothing`.

```@example indis
GedCom.birthlonlat(abe)
```
```@example indis
GedCom.deathlonlat(abe)
```
```@example indis
GedCom.buriallonlat(abe)
```

The `[X]location` functions return either `Location` object or `nothing`.  Note that `Location`s will always have a name for the location, but may have `nothing` for longitude and latitude values.


```@example indis
GedCom.birthlocation(abe)
```


```@example indis
GedCom.deathlocation(abe)
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