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
            #=
            if ! isempty(id)
                @debug("SOURCE: $(id)")
                @debug("Data: $(length(datalines)) lines.")
                  
                if length(datalines) > maxdatalines
                    maxdatalines = length(datalines)
                end
                  
                @info("Pushing source with $(length(datalines))data lines.")
                push!(sources, Source(id, datalines))
                
            end
            level = rec.level
            @info("SOUR at level $(level)")
            @info("ID IS $(rec.xrefId)")
            if isnothing(rec)
                @warn("EMPTY REC??", rec)
            end
            #
            #datalines = []
        
        end
        if level < rec.level
            push!(datalines, rec)
        end
    
    end
    if ! isnothing(id)
        src = Source(id, datalines)
        push!(sources, src)
        datalines = []
    end
    @info("Longest data record: $(maxdatalines)")
    parseSources
end=#
