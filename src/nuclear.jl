
"""Structure associating `Individual`s as a biological family comprising husband, wife and possibly empty list of children.
"""
struct NuclearFamily
    id
    husband
    wife
    children::Vector{Individual}
end


function ==(nf1::NuclearFamily, nf2::NuclearFamily)::Bool
    id(nf1) == id(nf2) &&
    husband(nf1) == husband(nf2) &&
    wife(nf1) == wife(nf2) &&
    children(nf1) == children(nf2) 
end


function id(nf::NuclearFamily)
    nf.id
end


function husband(nf::NuclearFamily)
    nf.husband
end

function wife(nf::NuclearFamily)
    nf.wife
end


function children(nf::NuclearFamily)
    nf.children
end


"""Override Base.show for `NuclearFamily`.
$(SIGNATURES)
"""
function show(io::IO, fam::NuclearFamily)
   write(io, label(fam))
end

"""Compose human-readable label for `f`.
"""
function label(f::NuclearFamily)
    hlabel = isnothing(f.husband) ? "unknown" : replace(f.husband.name, "/" => " ")
    cleanerhusband = replace(hlabel, r"[ ]+" => " ")
    wlabel = isnothing(f.wife) ? "unknown" : replace(f.wife.name, "/" => " ")
    cleanerwife = replace(wlabel, r"[ ]+" => " ")
    childrenlabel = length(f.children) == 1 ? string("(", length(f.children), " child)") : string("(", length(f.children), " children)")
    string(cleanerhusband, " -- ",  cleanerwife, " ", childrenlabel)
end


"""Get all instances of `NuclearFamily` where the person identifed by `id` 
is a parent.
"""
function families_asparent(id::S, gen::Genealogy)  where S <: AbstractString
    pers = individual(id, gen)
    isnothing(pers) ? [] :  families_asparent(pers, gen)
end

function families_asparent(pers::Individual, gen::Genealogy) 
    @debug("Get all nuke families for $(pers.personid)")
    map(family_ids_spouse(pers)) do famid
        @debug("Check $(famid)")
        nuclearfamily(famid, gen)
    end
end


"""Collect `Individual` objects for each member of the nuclear family
idenfied by `id`. Return a triple with `Individual` husband, `Individual` wife and Vector of `Individual` children.
"""
function nuclearfamily(id::S, gen::Genealogy)  where S <: AbstractString
    nuclearfamily(family(id,gen), gen)
end

"""Collect `Individual` objects for each member of a nuclear family.
Return a triple with `Individual` husband, `Individual` wife and Vector of `Individual` children.
"""
function nuclearfamily(fam::FamilyUnit, gen::Genealogy)
    # husband: 
    hmatches = filter(i -> i.personid == husbandid(fam), gen.individuals)
    h = isempty(hmatches) ? nothing : hmatches[1]
    wmatches = filter(i -> i.personid == wifeid(fam), gen.individuals)
    w = isempty(wmatches) ? nothing : wmatches[1]
    kids = map(childrenids(fam)) do kid
        filter(i -> i.personid == kid, gen.individuals)[1]
    end
    NuclearFamily(fam.xrefId, h, w, kids)
end

"""Construct nuclear family where `person` is a child.
"""
function nuclearfamily(person::Individual, gen::Genealogy)::Union{NuclearFamily, Nothing}
    @debug("Get nuke fam for indi")
    famid = family_id_child(person)
    if isnothing(famid)
        nothing
    else
        fam = family(famid, gen)
        nuclearfamily(fam, gen)
    end
end

"""Construct `NuclearFamily` objects for all families in a genealogy data set.
$(SIGNATURES)
"""
function nuclearfamilies(gen::Genealogy)::Vector{NuclearFamily}
    nuculars = NuclearFamily[]
    for f in gen.families
        push!(nuculars, nuclearfamily(f, gen))
    end
    nuculars
end


"""True if person has no family connections in this genealogy.
$(SIGNATURES)
"""
function singleton(personid, gen::Genealogy)::Bool
    pers = individual(personid, gen)
    singleton(pers, nuclearfamilies(gen))
end

"""True if a person is absent from the given list of nuclear families.
$(SIGNATURES)
"""
function singleton(indi::Individual, famlist::Vector{NuclearFamily})
    childfams = filter(f -> indi in children(f), famlist)
    parentfams = filter(f -> indi == husband(f) || indi == wife(f), famlist)
    isempty(parentfams) && isempty(childfams)
end

"""Find individuals in a genealogy with no connections to any
family units.
$(SIGNATURES)
"""
function singletons(gen::Genealogy)
    nfams = nuclearfamilies(gen)
    filter(indi -> singleton(indi, nfams), individuals(gen))
end