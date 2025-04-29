

#=
"""Look up a family unit in a genealogy by ID.
Returns a `FamilyUnit` or `nothing`.
"""
function family(id::S, gen::Genealogy)::Union{FamilyUnit, Nothing} where S <: AbstractString
    matches = filter(f -> f.xrefId == id, gen.families)
    length(matches) == 1 ? matches[1] : nothing  
end
=#

"""Compose a label for a `FamilyUnit`.
"""
function label(fam::FamilyUnit, gen::Genealogy)
    nuclearfamily(fam, gen ) |> label
end

#=
"""Extract a `Source` identified by its ID values from a `Genealogy`."""
function source(id, gen::Genealogy)
    srcmatches  = filter(src -> src.sourceId == id, gen.sources)
    if length(srcmatches) == 1
        srcmatches[1]
    elseif length(srcmatches > 1)
        @warn("Found more than one source with ID $(id)")
        []
    else
        []
    end
end
=#


"""Extract all `Source`s for an individual."""
function sources(indi::Individual)
  parseSources(indi.records)
end


"""Extract final four-digit year part of a string value.
"""
function yearpart(s)
    yearre = r".*(\d{4}$)"
    yrs = match(yearre,s)
    if isnothing(yrs)
        ""
    else
        yrs.captures[1]
    end
end

"""Find a single lon-lat pair within a block of lines.
Return a named tuple if both lon and lat are found,
or `nothing` if either lon or lat is missing.
"""
function lonlat(blk::Vector{GEDRecord})
    lon = GedCom.data(blk, "LONG")
    lat = GedCom.data(blk, "LATI")
    if isempty(lon) || isempty(lat)
        nothing
    else
        (lon = lon, lat = lat)
    end
end