
"""String value for birth date of an `Individual`.
"""
function birthdate(indi::Individual)
    birthlines = []
    inblock = false
    birthlevel = -1
    # get BIRT block
    for rec in indi.records
        if inblock
            if rec.level > birthlevel
                push!(birthlines, rec)
            else
                inblock = false
            end
        elseif rec.code == "BIRT"
            inblock = true
            birthlevel = rec.level
            @debug("Birth record at level $(birthlevel)")
        end
    end
    datelines = filter(rec -> rec.code == "DATE", birthlines)
    isempty(datelines) ? "n.d." : datelines[1].message
end

"""String value for death date of an `Individual`.
"""
function deathdate(indi::Individual)
    deathlines = []
    inblock = false
    deathlevel = -1
    # get BIRT block
    for rec in indi.records
        if inblock
            if rec.level > deathlevel
                push!(deathlines, rec)
            else
                inblock = false
            end
        elseif rec.code == "DEAT"
            inblock = true
            deathlevel = rec.level
            @debug("Death record at level $(deathlevel)")
        end
    end
    datelines = filter(rec -> rec.code == "DATE", deathlines)
    isempty(datelines) ? "" : datelines[1].message
end

function birthplace(indi::Individual)
end
function birthlonlat(indi::Individual)
end

function deathplace(indi::Individual)
end
function deathlonlat(indi::Individual)
end

function burialplace(indi::Individual)
end
function buriallonlat(indi::Individual)
end

function probate(indi::Individual)
end

function baptism(indi::Individual)
end

function residence(indi::Individual)
end

function occupation(indi::Individual)
end