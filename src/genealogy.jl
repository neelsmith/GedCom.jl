"""A `Genealogy` is composed of individuals, related in families,
and documented by source statements.
"""
struct Genealogy
    individuals::Vector{Individual}
    families::Vector{FamilyUnit}
    sources::Vector{Source}
end


function individuals(gen::Genealogy)
    gen.individuals
end

function familes(gen::Genealogy)
    gen.familes
end

function sources(gen::Genealogy)
    gen.sources
end


"""Override Base.show for `Genealogy`.
$(SIGNATURES)
"""
function show(io::IO, gen::Genealogy)
   write(io, "Genealogy records for $(length(gen.individuals)) persons.")
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
    matches = filter(i -> i.personid == id, gen.individuals)
    length(matches) == 1 ? matches[1] : nothing  
end

"""Look up a source in a genealogy by ID.
Returns a `Source` or `nothing`.
"""
function source(srcId::S, gen::Genealogy )::Union{Source, Nothing} where S <: AbstractString
    matches = filter(i -> srcId == i.sourceId, gen.sources)
    length(matches) == 1 ? matches[1] : nothing  
    #@warn("Looking up $(srcId) in genealogy.")
    #nothing
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
function descendant_generations(fam::FamilyUnit, gen::Genealogy,  count = 1)
    @debug("AT GENERATOIN $(count)")
    @debug("husband id " * husbandid(fam))
    husband = individual( husbandid(fam), gen)
    @debug(label(husband))
    @debug("wife id " * wifeid(fam))
    wife = individual( wifeid(fam), gen)
    @debug(label(wife))
    kids = childrenids(fam)
    @debug("$(length(kids)) children ")
    if ! isempty(kids)
        count = count + 1
    end
    @debug("So now counting at $(count)")
    for kid_id in kids
        kid = individual(kid_id, gen)
        nextmarriages =  family_ids_spouse(kid)
        @debug("Kid $(label(kid)): $(length(nextmarriages)) marriage(s)")

        for mrg in nextmarriages 
            nextfam = family(mrg, gen)
            count = descendant_generations( nextfam, gen, count)
        end
    end
    return count
end




"""Count number of ancestor generations in a genealogy from a given family unit.
$(SIGNATURES)
"""
function ancestor_generations(indi::Individual, gen::Genealogy, count = 1)
    @debug("AT GENERATOIN $(count)")
    @debug("individual " * label(indi))
    parenttuple = parents(indi, gen)
    rents = filter([parenttuple.father, parenttuple.mother]) do parent
        ! isnothing(parent)
    end
    if ! isempty(rents)
        @debug("Bumping gneeration count becase $(label(indi)) has parents $(label.(rents))")
        count = count + 1
    end


    fathercount = if isnothing(parenttuple.father) 
        @debug("Buit parenttuple.father is nothing!")
        count
    else
        newfather = ancestor_generations(parenttuple.father, gen,  count)
        @debug("Got new father count $(newfather)")
        newfather
    end
    @debug("Get max of $(fathercount), $(mothercount)")
    mothercount = isnothing(parenttuple.mother) ? count : ancestor_generations(parenttuple.mother, gen, count)
    count = maximum([fathercount, mothercount])
    @debug("Returning $(count)")

    return count

end


"""Compute a dictionary giving numbers of individuals at each generation.
$(SIGNATURES)
"""
function descendants_dimensions(fam::FamilyUnit, gen::Genealogy, count = 1, widths = Dict(1 => 1))
    pads = repeat("\t", count)
    @debug("$(pads)AT GENERATOIN $(count)")
    @debug("husband id " * husbandid(fam))
    husband = individual( husbandid(fam), gen)
    @debug(pads * "husband: " * label(husband))
    @debug("wife id " * wifeid(fam))
    wife = individual( wifeid(fam), gen)
    @debug(pads * "wife: " *label(wife))
    kids = childrenids(fam)
    @debug("$(length(kids)) children ")
    if ! isempty(kids)
        count = count + 1
    end
    @debug("So now counting at $(count)")

    if haskey(widths, count)
        widths[count] = widths[count] + length(kids)
    else
        widths[count] = length(kids)
    end
    @debug("THey have $(length(kids)) children")
    @debug("Added $(length(kids)), so width of gen. $(count) is now $(widths[count])")
    for kid_id in kids
        kid = individual(kid_id, gen)
        nextmarriages =  family_ids_spouse(kid)
        @debug("Kid $(label(kid)): $(length(nextmarriages)) marriage(s)")

        for mrg in nextmarriages 
            nextfam = family(mrg, gen)
            widths = descendants_dimensions(nextfam, gen,  count, widths)
        end
    end
    return widths
end


"""
"""
function descendants_plot_size(fam::FamilyUnit, gen::Genealogy)
    dimensionsdict = descendants_dimensions(fam, gen)

    ys = values(dimensionsdict) |> collect 
    breadth = ys |> maximum 
    
    xs = keys(dimensionsdict) |>  collect |> sort
    depth = xs |> maximum
    
    (depth, breadth)

end






function matchname(s, gen::Genealogy; gedcomsyntax = false)::Vector{Individual}
    if gedcomsyntax
        filter(i -> occursin(s, i.name), gen.individuals)
    else
        filter(gen.individuals) do indi
            simplename = replace(indi.name, "/" => "")
            occursin(s, simplename)
        end
    end
end