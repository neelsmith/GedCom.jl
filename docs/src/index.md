```@setup home
root = pwd() |> dirname |> dirname
f = joinpath(root, "test", "data", "pres2020.ged")
```

# `GedCom.jl`

> *Parse genealogical data following the Lineage-Linked Grammar of the GedCom 5.5.1 specification.*


## Quick start

In the examples throughout these pages, `f` is a file with more than 49,000 GEDCOM "records" documenting the genealogy of U.S. Presidents.

> This widely circulated GEDCOM data set was downloaded from [https://webtreeprint.com/tp\_famous\_gedcoms.php](https://webtreeprint.com/tp_famous_gedcoms.php).


Create a `Genealogy` from a file in GEDCOM format: 


```@example home
using GedCom
# `f` is a GedCom file, downloaded from:
# https://webtreeprint.com/tp_famous_gedcoms.php
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

