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
    re = r"[ ]*([0-9]) (@.+@)? ?([A-Z_]+) ?(.*)"
    lines = readlines(f)
    @info("Read $(length(lines)) lines.")
    records = GEDRecord[]
    for ln in filter(l -> ! isempty(l), lines)
        (digits, xrefid, code, content) = match(re, ln).captures
        gedRecord = GEDRecord(parse(Int64, digits), xrefid, code, content)
        push!(records, gedRecord)
    end
    records
end