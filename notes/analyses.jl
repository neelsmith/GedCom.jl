using GedCom

f = joinpath(pwd(),"test","data","pres2020.ged")
recc = GedCom.gedRecords(f)
gen = genealogy(f)

indilevel1s = []

for i in gen.individuals
    for r in i.records
        if r.level == 1
            push!(indilevel1s, r.code)
        end
    end
end



scores = []
for i in gen.individuals
    currlevel = 1
    currstack = ["","","",""]
    for r in i.records
        if r.level == 1
            push!(scores, currstack)
            currstack = ["","","",""]
        end
        id = "$(r.level)-$(r.code)"
        currstack[r.level] =  id
    end
end





famscores = []
for i in gen.families
    currlevel = 1
    currstack = ["","","",""]
    for r in i.records
        if r.level == 1
            push!(famscores, currstack)
            currstack = ["","","",""]
        end
        id = "$(r.level)-$(r.code)"
        currstack[r.level] =  id
    end
end