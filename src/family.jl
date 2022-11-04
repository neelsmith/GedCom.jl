# Maybe use just ids for everything in FamilyUnit
# and store all data in individuals?

struct FamilyUnit
    xrefId::AbstractString
    records
end


"""Extract `FamilyUnit`s from a GedCom file `f`.
"""
function families(f)
    gedRecords(f) |> parseFamilies
end


"""Parse a Vector of `FamilyUnit`s from a
Vector of `GEDRecord`s.
"""
function parseFamilies(records)
    families = FamilyUnit[]
    level = -1
    id = ""
    datalines = []
    for rec in records
        if rec.code == "FAM" 
            if ! isempty(id)
                @info("FAM: $(id)")
                @info("Data: $(datalines)")
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
    end
    families
end

"""Find individual ID for husband of a `FamilyUnit`.
"""
function husbandid(fam::FamilyUnit)
    filter(fam.records) do r
        r.code == "HUSB"
    end[1].message
end

"""Find individual ID for husband of a `FamilyUnit`.
"""
function wifeid(fam::FamilyUnit)
    filter(fam.records) do r
        r.code == "WIFE"
    end[1].message
end

"""Find individual IDs for children of a `FamilyUnit`.
"""
function childrenids(fam::FamilyUnit)
    chillun = filter(fam.records) do r
        r.code == "CHIL"
    end
    map(kid -> kid.message, chillun)
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