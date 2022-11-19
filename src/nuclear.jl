

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
