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

"""
Read `GEDRecord`s from file `f` where
`f` is a file following the GEDCOM 5.1.1 standard.
"""
function gedRecords(f)
    src = read(f) |> collect |> String
    @info("Read $(length(src )) characters.")
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
