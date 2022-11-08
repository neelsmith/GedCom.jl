"""An individual person.
"""
struct Individual
    id::AbstractString
    name::AbstractString
    records
end

"""Extracts any last name mareked by traditional slash convention;
alternatively, returns unaltered value of name property.
"""
function lastname(indi::Individual)
    #eplace(indi.name, "/" => "")
    re = r".*/(.+)/.*"
    slashed = match(re, indi.name)
    isnothing(slashed) ? indi.name : slashed.captures[1]
end

"""Format human-readable label for an `Individual`.
"""
function label(indi::Individual)
    fordates = dateslabel(indi)
    @debug("For dates; $(fordates) ")
    strippedname = replace(indi.name, "/" => "")
    isempty(fordates) ? strippedname  : string(strippedname,  " (", fordates, ")")
end

"Find string for sex value of `indi`."
function sex(indi::Individual)
    records = filter(rec -> rec.code == "SEX", indi.records)
    length(records) == 1 ? records[1].message : "Unrecorded"
end


"""Get parental family identifier for an `Individual`.
"""
function parentage(indi::Individual)
    records = filter(rec -> rec.code == "FAMC", indi.records)
    length(records) == 1 ? records[1].message : "Unrecorded"
end


"""Get list of spouses of an `Individual`.
"""
function spouses(indi::Individual)
    records = filter(rec -> rec.code == "FAMS", indi.records)
    map(r -> r.message, records)
end

"""Read file `f` and extract `Individual` objects.
"""
function individuals(f)
    gedRecords(f) |> parseIndividuals
end

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


"""Label for lifespan of an `Individual`.
"""
function dateslabel(indi::Individual)
    death = deathlabel(indi) |> yearpart
    birth = birthlabel(indi)  |> yearpart
    @debug("BIRTH PART $(birth)")
    if isempty(death) && birthlabel(indi) == "n.d." 
        birthlabel(indi) 
    elseif isempty(death)
        "b. " * birth
    else 
        string(birth, "-", death)
    end
end


"""Label for birth year of an `Individual`.
"""
function birthlabel(indi::Individual)
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


"""Label for death year of an `Individual`.
"""
function deathlabel(indi::Individual)
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


"""Given an ID number and its GEDCOM records,
create an `Individual`.
"""
function parseIndividual(id, records)
    namerecords = filter(rec -> rec.code == "NAME", records)
    isempty(namerecords) ? Individual(id, "", records) : Individual(id, namerecords[1].message,  records)

    #=
    Things we should should scan for:
        - √ sex
        - √ birth
        - √ death
        - √ family relations (FAMS, FAMC)
        - burial BURI
        - marriage, divorce MARR, DIV
        - probate PROB
        - baptism BAPM
        - residence RESI
        - occupation OCCU
    =#
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


