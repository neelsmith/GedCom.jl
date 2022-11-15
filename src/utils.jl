
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