# `GedCom.jl`

> Parse genealogical data following the Lineage-Linked Grammar of the GedCom 5.5.1 specification.


## Overview

Read a genealogical data set into a `Geneaology` object containing three vectors for top-level structures:

- individuals (`Vector{Invididual}`)
- family units (`Vector{FamilyUnit}`)
- sources (`Vector{Source}`)


Do that like this:

    gen = genealogy(FILE)


The package include functions for working with data about individuals, family units and sources, and relating them to each other.

## Individuals

## Family Units


## Sources





## Internals

- `Individual`
- `FamilyUnit`
- `NuclearFamily`
- `Geneaology`
- `GEDRecord`

An entire gedcom file is parsed into a `Genealogy` object.  It contains Vectors of `Individual`s `FamilyUnit`s.

`Individual`s and `FamilyUnit`s associate an identifier with its related block of `GEDRecord`s.  Data in the associated records are accessible from a bunch of functions.

The `NuclearFamily` groups together a husband, wife and list of children, each of which is an `Individual`.

Beyond that, there are events of various kinds and places. These are not yet modelled.

