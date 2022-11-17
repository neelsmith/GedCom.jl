struct Location
    label
    lon
    lat
end

function location(v::Vector{GEDRecord})
    ll = GedCom.lonlat(v)
    if isnothing(ll)
        Location(GedCom.data(v, "PLAC"), nothing, nothing)
    else
        Location(
            GedCom.data(v, "PLAC"),
            ll[:lon],
            ll[:lat]
        )
    end
end