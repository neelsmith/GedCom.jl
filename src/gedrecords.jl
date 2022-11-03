struct GEDRecord
    level::Integer
    xrefId
    code::AbstractString
    message::AbstractString
end


"""
Read GEDRecords from file `f`.
"""
function gedRecords(f)
    re = r"([0-9]) (@.+@)? ?([A-Z_]+) ?(.*)"
    lines = readlines(f)
    @info("Read $(length(lines)) lines.")
    records = []
    for ln in filter(l -> ! isempty(l), lines)
        (digits, xrefid, code, content) = match(re, ln).captures
        gedRecord = GEDRecord(parse(Int64, digits), xrefid, code, content)
        push!(records, gedRecord)
    end
    records
end