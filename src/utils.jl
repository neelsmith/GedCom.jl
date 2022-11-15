
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
