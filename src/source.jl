struct Source
    sourceId::AbstractString
    records
end


"""Extract `Source`s from a GedCom file `f`.
"""
function sources(f)
    gedRecords(f) |> parseSources
end


"""Parse a Vector of `Source`s from a
Vector of `GEDRecord`s.
"""
function parseSources(records)
    insource = false
    @info("Parsing $(length(records)) records")
    maxdatalines = 0
    sources = Source[]
    level = -1
    id = ""
    datalines = []
    for rec in records
        currlevel = rec.level
        if rec.code == "SOUR" && currlevel == 0
            id = rec.xrefId
            level = 0
            @debug("NEW SOURCE: $(id)")
            push!(sources, Source(id, datalines))
            datalines = []
            insource = true
        elseif currlevel == 0
            insource = false
        elseif insource
            push!(datalines, rec) 
        end
    end
    sources
end
         

function title(src::Source)
    data(src.records, "TITL")
end

function publication(src::Source)
    data(src.records, "PUBL")
end

function author(src::Source)
    data(src.records, "AUTH")
end

function repo(src::Source)
    data(src, "REPO")
end

function title(src::Source)
    data(src.records, "TITL")
end

#=
function data(src::Source, code)
    intitle = false
    currlevel = -1
    datastrings  = []
    for r in src.records
        if r.code == code
            currlevel = r.level
            push!(datastrings, r.message)
        elseif intitle && r.code == "CONC"
            push!(datastrings, r.message)
            currlevel = r.level
        elseif r.level >= currlevel
            intitle = false
        end
    end
    join(datastrings)
end
=#