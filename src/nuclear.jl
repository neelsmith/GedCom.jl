
"""Structure associating `Individual`s as a biological family comprising husband, wife and possibly empty list of children.
"""
struct NuclearFamily
    id
    husband
    wife
    children::Vector{Individual}
end


"""Compose human-readable label for `f`.
"""
function label(f::NuclearFamily)
    hlabel = isnothing(f.husband) ? "unknown" : replace(f.husband.name, "/" => "")
    wlabel = isnothing(f.wife) ? "unknown" : replace(f.wife.name, "/" => "")
    string(hlabel, "--",  wlabel)
end



"""Get all instances of `NuclearFamily` where the person identifed by `id` 
is a parent.
"""
function nuclearfamilies(id::S, gen::Genealogy)  where S <: AbstractString
    pers = individual(id, gen)
    isnothing(pers) ? [] :  nuclearfamilies(pers, gen)
end

function nuclearfamilies(pers::Individual, gen::Genealogy) 
    map(family_ids_spouse(pers)) do famid
        @debug("Check $(famid)")
        nuclearfamily(famid, gen)
    end
end

"""Collect `Individual` objects for each member of the nuclear family
idenfied by `id`. Return a triple with `Individual` husband, `Individual` wife and Vector of `Individual` children.
"""
function nuclearfamily(id::S, gen::Genealogy)  where S <: AbstractString
    nuclearfamily(familyunit(id,gen), gen)
end

"""Collect `Individual` objects for each member of a nuclear family.
Return a triple with `Individual` husband, `Individual` wife and Vector of `Individual` children.
"""
function nuclearfamily(fam::FamilyUnit, gen::Genealogy)
    # husband: 
    hmatches = filter(i -> i.id == husbandid(fam), gen.individuals)
    h = isempty(hmatches) ? nothing : hmatches[1]
    wmatches = filter(i -> i.id == wifeid(fam), gen.individuals)
    w = isempty(wmatches) ? nothing : wmatches[1]
    kids = map(childrenids(fam)) do kid
        filter(i -> i.id == kid, gen.individuals)[1]
    end
    NuclearFamily(fam.xrefId, h, w, kids)
end

"""Construct nuclear family where `person` is a child.
"""
function nuclearfamily(person::Individual, gen::Genealogy)
    famid = family_id_child(person)
    fam = familyunit(famid, gen)
    nuclearfamily(fam, gen)
end