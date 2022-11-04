# Yay, docs

Parse a GedCom file following the GedCom 5.5.1 spec for the Lineage-Linked Grammar.


## Structures

- `Individual`
- `FamilyUnit`
- `NuclearFamily`
- `Geneaology`
- `GEDRecord`

An entire gedcom file is parsed into a `Genealogy` object.  It contains Vectors of `Individual`s and `FamilyUnit`s.

`Individual`s and `FamilyUnit`s associate an identifier with its related block of `GEDRecord`s.  Data in the associated records are accessible from a bunch of functions.

The `NuclearFamily` groups together a husband, wife and list of children, each of which is an `Individual`.

Beyond that, there are events of various kinds and places. These are not yet modelled.


## Constructing from a file

- get a file handle
- `genealogy(FILE)`