
struct Individual
    id::AbstractString
    name::AbstractString
end

function individuals(f)
    gedRecords(f) |> parseIndividuals
end

function parseIndividual(id, records)
    Individual(id, "")
end


function parseIndividuals(records)
    individuals = Individual[]
    level = -1
    id = ""
    indilines = []
    for rec in records
        if rec.code == "INDI" 
            if ! isempty(id)
                @info("INDI: $(id)")
                @info("Data: $(indilines)")
                indiv = parseIndividual(id, indilines)
                push!(individuals, indiv)
            end
            level = rec.level
            id = rec.xrefId
            indilines = []
        end
        if level < rec.level
            push!(indilines, rec)
            #@info("")
        end
    end
    if ! isnothing(id)
        indiv = parseIndividual(id, indilines)
        push!(individuals, indiv)
    end
    individuals
end


