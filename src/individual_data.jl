
"""String value for birth date of an `Individual`,
or "n.d." if unknown.
"""
function birthdate(indi::Individual)
    birthdata = GedCom.blocks(indi.records, "BIRT")
    if isempty(birthdata)
        "n.d."
    else
        datestr = GedCom.data(birthdata[1], "DATE")
        isempty(datestr) ? "n.d." : datestr
    end
end

"""`Location` object for birth site of `indi`,
or `nothing` if none found.
"""
function birthlocation(indi::Individual)
   lbl = birthplace(indi)
   ll = birthlonlat(indi)
   if isempty(lbl)
    nothing
   else
    if isnothing(ll)
        Location(lbl, nothing, nothing)
    else
        Location(lbl, ll[:lon], ll[:lat])
    end
   end
end

"""String value for birth site of an `Individual`,
or empty string if unknown.
"""
function birthplace(indi::Individual)
    recc = GedCom.blocks(indi.records, "BIRT")
    if isempty(recc)
        ""
    else
        GedCom.data(recc[1], "PLAC")
    end
end

"""Lon/lat pair for birth site of an `Individual`,
or `nothing` if unknown.
"""
function birthlonlat(indi::Individual)
    birthdata = GedCom.blocks(indi.records, "BIRT")
    if isempty(birthdata)
        nothing
    else
        GedCom.lonlat(birthdata[1])
    end
end

"""String value for death date of an `Individual`.
"""
function deathdate(indi::Individual)
    deathdata = GedCom.blocks(indi.records, "DEAT")
    if isempty(deathdata)
        "n.d."
    else
        datestr = GedCom.data(deathdata[1], "DATE")
        isempty(datestr) ? "n.d." : datestr
    end  
end


"""`Location` object for death site of `indi`,
or `nothing` if none found.
"""
function deathlocation(indi::Individual)
   lbl = deathplace(indi)
   ll = deathlonlat(indi)
   if isempty(lbl)
    nothing
   else
    if isnothing(ll)
        Location(lbl, nothing, nothing)
    else
        Location(lbl, ll[:lon], ll[:lat])
    end
   end
end

"""String value for death site of an `Individual`,
or empty string if unknown.
"""
function deathplace(indi::Individual)
    recc = GedCom.blocks(indi.records, "BIRT")
    if isempty(recc)
        ""
    else
        GedCom.data(recc[1], "PLAC")
    end
end

"""Lon/lat pair for death site of an `Individual`,
or `nothing` if unknown.
"""
function deathlonlat(indi::Individual)
    recc = GedCom.blocks(indi.records, "BIRT")
    if isempty(recc)
        nothing
    else
        GedCom.lonlat(recc[1])
    end
end

"""`Location` object for burial site of `indi`,
or `nothing` if none found.
"""
function buriallocation(indi::Individual)
    lbl = burialplace(indi)
    ll = buriallonlat(indi)
    if isempty(lbl)
        nothing
    else
        if isnothing(ll)
            Location(lbl, nothing, nothing)
        else
            Location(lbl, ll[:lon], ll[:lat])
        end
   end
end

"""String value for burial site of an `Individual`,
or empty string if unknown.
"""
function burialplace(indi::Individual)
    recc = GedCom.blocks(indi.records, "BURI")
    if isempty(recc)
        ""
    else
        GedCom.data(recc[1], "PLAC")
    end
end

"""Lon/lat pair for burial site of an `Individual`,
or `nothing` if unknown.
"""
function buriallonlat(indi::Individual)
    recc = GedCom.blocks(indi.records, "BURI")
    if isempty(recc)
        nothing
    else
        GedCom.lonlat(recc[1])
    end
end






###  TBD ########################################
function probate(indi::Individual)
end

function baptism(indi::Individual)
end

function residence(indi::Individual)
end

function occupation(indi::Individual)
end