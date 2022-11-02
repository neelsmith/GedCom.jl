function gedtriples(f)
    re = r"([0-9]) ([A-Z_@]+) ?(.*)"
    lines = readlines(f)
    @info("Read $(length(lines)) lines.")
    triples = []
    for ln in filter(l -> ! isempty(l), lines)
        @info("READ $(ln)")
        (digits, code, content) = match(re, ln).captures
        push!(triples, (digits, code, content))
    end
    triples
end