```@setup datawork

root = pwd() |> dirname |> dirname
f = joinpath(root, "test", "data", "pres2020.ged")

```



# Extracting data directly from Vectors of `GEDRecord`s

You can extract named content directly from vectors of `GEDRecords`, such as the records associated with each `Individual`, `FamilyUnit` or `Source`.

You can also use the `gedRecords` function to parse a file in GEDCOM format directly into a sequence of `GEDRecord` objects.  


```@example datawork
using GedCom
records = gedRecords(f)
typeof(records)
```

## The GEDCOM standard

The [specification for version 5.5.1 of the GEDCOM standard](https://gedcom.io/specifications/ged551.pdf) describes a GEDCOM database like this:


> "A GEDCOM transmission represents a database in the form of a sequential stream of related records. A record is represented as a sequence of tagged, variable-length lines, arranged in a hierarchy."

The structure of the `GEDRecord` directly mimics the components of a record in the GEDCOM specification.  Each record has a hierarchical level (and integer) and a tag (a four-character string), plus either an identifier (called an "xrefID") or a text value.  Pointers are either `nothing` or a string value beginning and ending with `@`; the text value is just a (possibly empty) string.  For some GEDCOM 5.5.1 tags, the text value is the identifier for another record; this is how GEDCOM the lineage-linked grammar relates different content items.

Here's what a few records look like:

```@example datawork
records[101:115]
```


## Extracting blocks of data

GEDCOM records are organized in a hierarchy.  

Extract groups records with the `GedCom.blocks` function.  A "block" is just a vector of `GEDRecord`s, so the result of this function is a vector of vectors of `GEDRecord`s.

```@example datawork
burials = GedCom.blocks(records, "BURI")
typeof(burials)
```

Each individual block in this vector is the group of records hierarchically subordinated to the top element of the given type (here, burials indicated by the type tag "BURI").

```@example datawork
lastburial = burials[end]
```

## Data

Use the `GedCom.data` function to extract the text content for a record.  Here, we can extract the label for the place of the previous burial from the "PLAC" record.

```@example datawork
GedCom.data(lastburial, "PLAC")
```

The `GedCom.data` function will append string data from records tagged as "CONC" (concatenate) or "CONT" (continue).

You can use the `GedCom.blocks` and `GedCom.data` functions to work directly with the `GEDRecord`s that are part of the higher-order structures of `Individual`, `FamilyUnit` and `Source`.

In the presidential data set, the eighteenth individual in the data set, Simpson Green Ayers, has a single block documenting his residence.  We could extract it like this:

```@example datawork
people = individuals(f)
simpson = people[18]
residence = GedCom.blocks(simpson.records, "RESI")[1]
```

We could extract the text content of the record tagged "RESI"  directly from the records associated with the Ayers. Note that content from the following "CONC" block is included.

```@example datawork
GedCom.data(simpson.records, "RESI")
```

## Utility functions

The `GedCom.lonlat` function extracts a single pair of geographic coordinates from a vector of blocks.  We can use it to get the geographic location for his residence record.

```@example datawork
GedCom.lonlat(residence)
```