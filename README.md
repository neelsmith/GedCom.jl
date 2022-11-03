# GedCom.jl

Parse GedCom file following GedCom 5.5.1 spec.

The central units are the individual, the family unit, and the source. (A fourth is the repository: not yet handled.)

Family units are have IDs only; otherwise, they are composed of relations that are assembled from data about individuals.

Individuals are associated with each other in family units.

Tested with data emitted by ancestry.com.