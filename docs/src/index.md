```@setup home
root = pwd() |> dirname |> dirname
f = joinpath(root, "test", "data", "pres2020.ged")
```

# `GedCom.jl`

> *Parse genealogical data following the Lineage-Linked Grammar of the GedCom 5.5.1 specification.*


## The GEDCOM standard

The [specification for version 5.5.1 of the GEDCOM standard](https://gedcom.io/specifications/ged551.pdf) describes a GEDCOM database like this:


> "A GEDCOM transmission represents a database in the form of a sequential stream of related records. A record is represented as a sequence of tagged, variable-length lines, arranged in a hierarchy."

You can use the `gedRecords` function to parse a file in GEDCOM format into a sequence of `GEDRecord` objects.  In this example, `f` is a file with more than 49,000 GEDCOM "records" documenting the genealogy of U.S. Presidents.



```@example home
using GedCom
records = gedRecords(f)
typeof(records)
```

> This widely circulated GEDCOM data set was downloaded from [https://webtreeprint.com/tp_famous_gedcoms.php](https://webtreeprint.com/tp_famous_gedcoms.php).




The structure of the `GEDRecord` directly mimics the components of a record in the GEDCOM specification.  Each record has a hierarchical level (and integer) and a tag (a four-character string), plus either an identifier (called an "xrefID") or a text value.  Pointers are either `nothing` or a string value beginning and ending with `@`; the text value is just a (possibly empty) string.  For some GEDCOM 5.5.1 tags, the text value is the identifier for another record; this is how GEDCOM the lineage-linked grammar relates different content items.

Here's what a few records look like:

```@example home
records[101:115]
```


## A GEDCOM genealogy

The `GedCom` package includes abstractions that let you work the genealogical content without having to worry about the structure of the GEDCOM format.  With the `genealogy` function, we can read the same file into a single `Genealogy` object.

```@example home
gen = genealogy(f)
typeof(gen)
```

A `Genealogy` object has three vectors of genealogical content modelling individuals, family units, and sources of information.

```@example home
gen.individuals |> typeof
```


```@example home
gen.families |> typeof
```
```@example home
gen.sources |> typeof
```

The following pages illustrate functions for working with each of these three types of data, and for relating them to each other.

