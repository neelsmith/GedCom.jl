```@setup datawork

root = pwd() |> dirname |> dirname
f = joinpath(root, "test", "data", "pres2020.ged")

```

# Extracting data directly from Vectors of `GEDRecord`s

You can extract named content directly from vectors of `GEDRecords`.


## Reading a GEDCOM source

First, let's collect a lot of `GEDRecord`s by reading a file. (In this example, `f` is the file `pres2020.ged` in the `test/data` directory of this repository.)

The `gedRecords` function creates a Vector of `GEDRecord`s.

```@example datawork
using GedCom
records = gedRecords(f)
typeof(records)
```

There are a lot of them in this file.

```@example datawork
length(records)
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