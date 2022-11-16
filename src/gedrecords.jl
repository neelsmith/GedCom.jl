"""A GEDRecord is the content of a single line 
of a GEDCOM "transmission."

The GEDCOM 5.1.1 spec defines four required and one optional element in each record.
"""
struct GEDRecord
    level::Integer
    xrefId # Union of AbstractString or Nothing
    code::AbstractString
    message::AbstractString
end

"""Override `==` for `GEDRecord` type.
"""
function ==(r1::GEDRecord, r2::GEDRecord)
    r1.level == r2.level &&
    r1.xrefId == r2.xrefId &&
    r1.code == r2.code &&
    r1.message == r2.message
end

"""
Read `GEDRecord`s from file `f` where
`f` is a file following the GEDCOM 5.1.1 standard.
"""
function gedRecords(f)
    src = read(f) |> collect |> String
    @debug("Read $(length(src )) characters.")
    gedRecords(split(src, r"[\n\r]+"))
end

"""
Read `GEDRecord`s from a Vector of lines
following the GEDCOM 5.1.1 standard for a "record".
"""
function gedRecords(lns::Vector{T}) where T <: AbstractString
    gedre = r"[ ]*([0-9]) (@.+@)? ?([A-Z_]+) ?(.*)"
    records = GEDRecord[]
    for ln in filter(l -> ! isempty(l), lns)
        (digits, xrefid, code, content) = match(gedre, ln).captures
        gedRecord = GEDRecord(parse(Int64, digits), xrefid, code, content)
        push!(records, gedRecord)
    end
    records
end


"""Given a Vector of `GEDRecord`s, extract data values for al. records of a specific code. In addition to extracting the `message`
field of the records tagged with `code`, continuation of those records with `CONC` or `CONT` codes is respected.

Compare `blocks(v, code)`.
"""
function data(v::Vector{GEDRecord}, code)
    incode = false
    currlevel = -1
    datastrings  = []
    for r in v
        if r.code == code
            currlevel = r.level
            incode = true
            @debug("FOUND $(code): pushing $(r)")
            push!(datastrings, r.message)
        elseif incode && 
            (r.code == "CONC" || r.code == "CONT")
            push!(datastrings, r.message)
            currlevel = r.level
        elseif r.level >= currlevel
            incode = false
        end
    end
    join(datastrings)
end

"""Given a Vector of `GEDRecord`s, extract blocks of `GEDRecord`s for a given GEDCOM code.  A "block" is a series of subsequent GEDCOM records contained in that code unit, as indicated by the level of subordination of the record. 

Compare `data(v, code)`.
"""
function blocks(v::Vector{GEDRecord}, code)::Vector{Vector{GEDRecord}}
    inblock = false
    blocklevel = -1
    blocklist = Vector{GEDRecord}[]
    currentdata = GEDRecord[]
    for r in v
        @debug(" ---> $(r)")
        if r.code == code 
            blocklevel = r.level
            if ! isempty(currentdata) 
                push!(blocklist, currentdata)
            end
            currentdata = [r]
            inblock = true
            @debug("Found block $(code): blocklevel $(blocklevel)")
        elseif r.level <= blocklevel 
            if  ! isempty(currentdata) 
                push!(blocklist, currentdata)
            end
            inblock = false
            currentdata = []
        elseif inblock
            @debug("Should push: $(r)")
            push!(currentdata, r)
        end
    end
    if ! isempty(currentdata) 
        push!(blocklist, currentdata)
    end
    blocklist
end