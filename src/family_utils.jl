


"""Look up a family unit in a genealogy by ID.
Returns an `FamilyUnit` or `nothing`.
"""
function familyunit(id::S, gen::Genealogy)::Union{FamilyUnit, Nothing} where S <: AbstractString
    matches = filter(f -> f.xrefId == id, gen.families)
    length(matches) == 1 ? matches[1] : nothing  
end


"""Compose a label for a `FamilyUnit`.
"""
function label(fam::FamilyUnit, gen::Genealogy)
    nuclearfamily(fam, gen ) |> label
end
