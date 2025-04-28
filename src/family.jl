"""Identifier and ordered list of `GEDRecord`s for a single family unit.
"""
struct FamilyUnit
    xrefId::AbstractString
    records::Vector{GEDRecord}
end



"""Override Base.show for `FamilyUnit`.
$(SIGNATURES)
"""
function show(io::IO, fam::FamilyUnit)
   show(io, "Family $(fam.xrefId) ($(length(fam.records)) GEDCOM records)")
end


"""Extract `FamilyUnit`s from a GedCom file `f`.
"""
function families(f)
    gedRecords(f) |> parseFamilies
end

function hoh(id::AbstractString, gen)
    idmatches = filter(gen.families) do fam
        fam.xrefId == id
    end
    isempty(idmatches) ? nothing : hoh(idmatches[1], gen)
end
function hoh(fam::FamilyUnit, gen)
    wifematches = filter(fam.records) do r
        r.code == "WIFE"
    end

    wifeid = if isempty(wifematches) 
        ""
    else
        wifematches[1].message
    end
    wife = filter(gen.individuals) do indi
        indi.id == wifeid
    end

    husbandmatches = filter(fam.records) do r
        r.code == "HUSB"
    end
    husbandid = if isempty(husbandmatches) 
        ""
    else
        husbandmatches[1].message
    end

    husband = filter(gen.individuals) do indi
        indi.id == husbandid
    end
    wife = filter(gen.individuals) do indi
        indi.id == wifeid
    end
    if ! isempty(wife) &&
        ! isempty(husband)
        string(label(husband[1]), " + ", label(wife[1]))
    elseif isempty(wife)
        string("Mother: $(label(wife[1]))")
    else
        string("Father: $(label(husband[1]))")
    end
end

"""Parse a Vector of `FamilyUnit`s from a Vector of `GEDRecord`s.
"""
function parseFamilies(records)
    maxdatalines = 0
    families = FamilyUnit[]
    level = -1
    id = ""
    datalines = []
    for rec in records
        if rec.code == "FAM" 
            if ! isempty(id)
                @debug("FAM: $(id)")
                @debug("Data: $(length(datalines)) lines.")
                if length(datalines) > maxdatalines
                    maxdatalines = length(datalines)
                end
                @debug("Pushing family with $(length(datalines))data lines.")
                push!(families, FamilyUnit(id, datalines))
            end
            level = rec.level
            id = rec.xrefId
            datalines = []
        end
        if level < rec.level
            push!(datalines, rec)
        end
    end
    if ! isnothing(id)
        family = FamilyUnit(id, datalines)
        push!(families, family)
        datalines = []
    end
    @debug("Longest data record: $(maxdatalines)")
    families
end



"""Find individual ID for husband of a `FamilyUnit`.
"""
function husbandid(fam::FamilyUnit)
    husbandrecord = filter(fam.records) do r
        r.code == "HUSB"
    end
    isempty(husbandrecord) ? "" :    husbandrecord[1].message
end

"""Find individual ID for husband of a `FamilyUnit`.
"""
function wifeid(fam::FamilyUnit)
    wiferecord = filter(fam.records) do r
        r.code == "WIFE"
    end
    isempty(wiferecord) ? "" : wiferecord[1].message
end

"""Find individual IDs for children of a `FamilyUnit`.
"""
function childrenids(fam::FamilyUnit)
    chillun = filter(fam.records) do r
        r.code == "CHIL"
    end
    map(kid -> kid.message, chillun)
end

"""Find marriage date for `fam`.
The result is a human-readable string, or, if no date is recorded, an empty string.
"""
function marriagedate(fam::FamilyUnit)
    blks = GedCom.blocks(fam.records,"MARR")
    if length(blks) == 1
        GedCom.data(blks[1], "DATE")
    else
        ""
    end
end

"""Find name of place where marriage
took place for `fam`.  
The result is a human-readable name for a place or, if no date is recorded, an empty string.
"""
function marriageplace(fam::FamilyUnit)
    blks = GedCom.blocks(fam.records,"MARR")
    if length(blks) == 1
        GedCom.data(blks[1], "PLAC")
    else
        ""
    end
end

"""Find longitude, latitude pair
for location where marriage took place for `fam`.  The result is a named tuple, or, if no result is found, `nothing`.
"""
function marriagelonlat(fam::FamilyUnit)
    blks = GedCom.blocks(fam.records,"MARR")
    if length(blks) == 1
        lon = GedCom.data(blks[1], "LONG")
        lat = GedCom.data(blks[1], "LATI")
        if isempty(lon) || isempty(lat)
            nothing
        else
            (lon = lon, lat = lat)
        end
    else
        nothing
    end
end

#= Example:

0 @F2@ FAM
1 HUSB @I3@
1 WIFE @I4@
1 CHIL @I1@
2 _FREL Natural
2 _MREL Natural
1 MARR
2 DATE 3 SEP 1943
2 PLAC Texarkana, Miller, Arkansas, USA
3 MAP
4 LATI N33.4418
4 LONG W94.0377
=#
