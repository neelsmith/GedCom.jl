"""A `Genealogy` is composed of individuals, related in families,
and documented by source statements.
"""
struct Genealogy
    individuals::Vector{Individual}
    families::Vector{FamilyUnit}
    sources::Vector{Source}
end

"""Build a `Genealogy` from a GEDCOM file source.
"""
function genealogy_g5(f)::Genealogy
    folks = individuals(f)
    fams = families(f)
    srcs = sources(f)
    Genealogy(folks, fams, srcs)
end

"""Build a `Genealogy`from a string of GEDCOM data.
"""
function fromgedcom(s)
    grecords = gedRecords(f)

    Genealogy(parseIndividuals(grecords), parseFamilies(grecords), parseSources(grecords))
end

"""Look up an individual in a genealogy by ID.
Returns an `Individual` or `nothing`.
"""
function individual(id::S, gen::Genealogy )::Union{Individual, Nothing} where S <: AbstractString
    matches = filter(i -> i.id == id, gen.individuals)
    length(matches) == 1 ? matches[1] : nothing  
end



"""Look up a family in a genealogy by ID.
Returns a `FamilyUnit` or `nothing`.
"""
function family(id::S, gen::Genealogy )::Union{FamilyUnit, Nothing} where S <: AbstractString
    matches = filter(f -> f.xrefId == id, gen.families)
    length(matches) == 1 ? matches[1] : nothing  
end






"""Count number of generations in a genealogy descending from 
a given family unit.
$(SIGNATURES)
"""
function descendant_generations(gen::Genealogy, fam::FamilyUnit, count = 0)
    @info("AT GENERATOIN $(count)")
    @info("husband id " * husbandid(fam))
    husband = individual( husbandid(fam), gen)
    @info(label(husband))
    @info("wife id " * wifeid(fam))
    wife = individual( wifeid(fam), gen)
    @info(label(wife))
    kids = childrenids(fam)
    @info("$(length(kids)) children ")
    if ! isempty(kids)
        count = count + 1
    end
    @info("So now counting at $(count)")
    for kid_id in kids
        kid = individual(kid_id, gen)
        nextmarriages =  family_ids_spouse(kid)
        @info("Kid $(label(kid)): $(length(nextmarriages)) marriage(s)")

        for mrg in nextmarriages 
            nextfam = family(mrg, gen)
            count = descendant_generations(gen, nextfam, count)
        end
        #count = descendant_generations(gen, )
    end
    return count
end




"""Count number of ancestor generations in a genealogy from a given family unit.
$(SIGNATURES)
"""
function ancestor_generations(gen::Genealogy, indi::Individual, count = 0)
    @info("AT GENERATOIN $(count)")
    @info("individual " * label(indi))
    parenttuple = parents(indi, gen)
    rents = filter([parenttuple.father, parenttuple.mother]) do parent
        ! isnothing(parent)
    end
    if ! isempty(rents)
        @info("Bumping gneeration count becase $(label(indi)) has parents $(label.(rents))")
        count = count + 1
    end


    fathercount = if isnothing(parenttuple.father) 
        @info("Buit parenttuple.father is nothing!")
        count
    else
        newfather = ancestor_generations(gen, parenttuple.father, count)
        @info("Got new father count $(newfather)")
        newfather
    end
    mothercount = isnothing(parenttuple.mother) ? count : ancestor_generations(gen, parenttuple.mother, count)
    @info("Get max of $(fathercount), $(mothercount)")
    count = maximum([fathercount, mothercount])
    @info("Returning $(count)")

    return count

end