
struct FamilyUnit
    xrefId::AbstractString
    husband
    wife
    children
end


function families(f)
    gedRecords(f) |> parseFamilies
end

function parseFamily(id, records)
    FamilyUnit(id, "", "", [])
end

function parseFamilies(records)
    families = FamilyUnit[]
    level = -1
    id = ""
    datalines = []
    for rec in records
        if rec.code == "FAM" 
            if ! isempty(id)
                @info("INDI: $(id)")
                @info("Data: $(datalines)")
                fam = parseFamily(id, datalines)
                push!(families, fam)
            end
            level = rec.level
            id = rec.xrefId
            datalines = []
        end
        if level < rec.level
            push!(datalines, rec)
            #@info("")
        end
    end
    if ! isnothing(id)
        family = parseFamily(id, datalines)
        push!(families, family)
    end
    families
end
