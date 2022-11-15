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

GEDCOM records have a hierarchical level.

Extract hierarchically grouped records with the `GedCom.blocks` function.
```@example datawork
burials = GedCom.blocks(records, "BURI")
```
```@example datawork
burials[end]
```

## Data