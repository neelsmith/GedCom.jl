"""An individual person.
"""
struct Individual
    personid::AbstractString
    name::AbstractString
    records::Vector{GEDRecord}
end



function id(indi::Individual)
    indi.personid
end

"""Override Base.show for `Individual`.
$(SIGNATURES)
"""
function show(io::IO, indi::Individual)
   write(io, label(indi))
end



function name(indi::Individual)
    replace(indi.name, "/" => "")
end

"""Extracts any last name marked by GEDCOM's traditional slash convention;
alternatively, returns unaltered value of name property.
"""
function lastname(indi::Individual)
    re = r".*/(.+)/.*"
    slashed = match(re, indi.name)
    isnothing(slashed) ? indi.name : slashed.captures[1]
end

"""Format human-readable label for an `Individual`.
"""
function label(indi::Individual)
    fordates = dateslabel(indi)
    @debug("For dates; $(fordates) ")
    strippedname = replace(indi.name, "/" => " ") |> strip
    cleaner = replace(strippedname, r"[ ]+" => " ")
    @debug("Stripped = /$(strippedname)/")
    isempty(fordates) ? cleaner  : string(cleaner,  " (", fordates, ")")
end

"Find string for sex value of `indi`."
function sex(indi::Individual)
    records = filter(rec -> rec.code == "SEX", indi.records)
    length(records) == 1 ? records[1].message : "Unrecorded"
end


"""Get family identifier for the family in which individual is a child.
"""
function family_id_child(indi::Individual)
    records = filter(rec -> rec.code == "FAMC", indi.records)
    length(records) == 1 ? records[1].message : nothing
end


"""Get list of identifiers for family units in which an individual is a spouse.
"""
function family_ids_spouse(indi::Individual)
    records = filter(rec -> rec.code == "FAMS", indi.records)
    map(r -> r.message, records)
end

"""Label for lifespan of an `Individual`.
"""
function dateslabel(indi::Individual)
    death = deathdate(indi) |> yearpart
    birth = birthdate(indi)  |> yearpart
    @debug("BIRTH PART $(birth)")
    if isempty(death) && birthdate(indi) == "n.d." 
        birthdate(indi) 
    elseif isempty(death)
        "b. " * birth
    else 
        string(birth, "-", death)
    end
end



"""Read file `f` and extract `Individual` objects.
"""
function individuals(f)
    gedRecords(f) |> parseIndividuals
end



"""Given an ID number and its GEDCOM records,
create an `Individual`.
"""
function parseIndividual(id, records)
    namerecords = filter(rec -> rec.code == "NAME", records)
    isempty(namerecords) ? Individual(id, "", records) : Individual(id, namerecords[1].message,  records)
end

"""From a Vector of `GEDRecord`s, create a Vector
of `Individual`s.
"""
function parseIndividuals(records)
    individuals = Individual[]
    level = -1
    id = ""
    indilines = []
    for rec in records
        if rec.code == "INDI" 
            if ! isempty(id)
                @debug("INDI: $(id)")
                @debug("Data: $(indilines)")
                indiv = parseIndividual(id, indilines)
                push!(individuals, indiv)
            end
            level = rec.level
            id = rec.xrefId
            indilines = []
        end
        if level < rec.level
            push!(indilines, rec)
        end
    end
    if ! isnothing(id)
        indiv = parseIndividual(id, indilines)
        push!(individuals, indiv)
    end
    individuals
end


function undocumented(indi::Individual)::Bool
    GedCom.blocks(indi.records, "SOUR") |> isempty
end