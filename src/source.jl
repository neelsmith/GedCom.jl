"""In GEDCOM 5, a source is a hierarchical set of GEDCOM records."""
struct Source
    sourceId::AbstractString
    records::Vector{GEDRecord}
end



"""Extract `Source`s from a GedCom file `f`.
"""
function sources(f)
    gedRecords(f) |> parseSources
end

"""Extract `Source`s from a Vector of string data.
"""
function sources(v::Vector{T}) where T <: AbstractString
    gedRecords(v) |>    parseSources
end

"""Parse a Vector of `Source`s from a
Vector of `GEDRecord`s.
"""
function parseSources(records)
    insource = false
    @debug("Parsing $(length(records)) records for sources")
    maxdatalines = 0
    sources = Source[]
    level = -1
    id = ""
    datalines = []
    for rec in records
        currlevel = rec.level
        if rec.code == "SOUR" && currlevel == 0
            if ! isempty(id)
                push!(sources, Source(id, datalines))
            end
            id = rec.xrefId
            level = 0
            @debug("NEW SOURCE: $(id)")
            datalines = []
            insource = true
        elseif currlevel == 0
            insource = false
        elseif insource
            push!(datalines, rec) 
        end
    end
    if ! isempty(id)
        push!(sources, Source(id, datalines))
    end
    sources
end
    

"""Get string value for title of `src`.
"""
function title(src::Source)
    data(src.records, "TITL")
end

"""Get string value for publication information of `src`.
"""
function publication(src::Source)
    data(src.records, "PUBL")
end

"""Get string value for author of `src`.
"""
function author(src::Source)
    data(src.records, "AUTH")
end


"""Get ID for repository of `src`.
"""
function repo(src::Source)
    data(src.records, "REPO")
end