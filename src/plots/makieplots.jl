
"""Plot a family unit on axis with a point for parents, and points for children, then recursively apply to any children who have family units.
"""
function descendants_points!(genpoint::FamilyUnit, gen::Genealogy, ax::Axis; parentpoint = nothing, gencount = 1, orientation = :lr, genscale = 50, margin = 20)
    (depth, breadth) = descendants_plot_size(genpoint, gen)
    figheight = 2 * margin +  breadth * genscale
    figwidth = 2 * margin + genscale * depth  + genscale  


    husband = individual( husbandid(genpoint), gen)
    wife = individual( wifeid(genpoint), gen)
    @info("Plot point for family $(name(husband)) / $(name(wife)) at generation $(gencount)")


    currentpoint = Point(0.0,0.0)
    if isnothing(parentpoint)
        @info("This is the first point on the figure")
        currentpoint = Point(0, figheight / 2)
        scatter!(ax, [currentpoint], color = [:blue])
        famlabel = string(name(husband), " m. ", name(wife))
        text!([currentpoint], text = [famlabel], align = (:right, :center))
    else
        currentpoint = parentpoint
    end

    @debug("Plotting with parent familhy at $(currentpoint)")

    kids = childrenids(genpoint)
    @debug("They have $(length(kids)) children")

    gencount = gencount + 1

    
    for (i, kidid) in enumerate(kids)
        
        kidpt = Point(gencount * genscale, (i - 1) * genscale)
        scatter!(ax, [kidpt], color = [:blue])
        lines!([currentpoint, kidpt], color = :gray, linewidth = 1)

        @debug("Type $(typeof(kidid)) with $(kidid)")
        kid = individual(kidid, gen)
        @info("\tchild $(i). $(name(kid))")


        mrgs =  family_ids_spouse(kid)
        if isempty(mrgs)
            text!([currentpoint], text = [name(kid)], align = (:right, :center), color = :blue)
        end

        for famid in mrgs
            kidfamily =  family(famid, gen)
            descendants_points!(kidfamily, gen, ax; gencount = gencount, parentpoint = kidpt)
            husband = individual( husbandid(kidfamily), gen)
            wife = individual( wifeid(kidfamily), gen)
            txtlabel = name(husband) * " m. " * name(wife)
            if gencount > 2
                text!([currentpoint], text = [txtlabel], align = (:right, :center))
            end
        end

    end

end

function descendants_plot(fam::FamilyUnit, gen::Genealogy; orientation = :lr, genscale = 50, margin = 20)
    (depth, breadth) = descendants_plot_size(fam, gen)

    figheight = 2 * margin +  breadth * genscale
    figwidth = 2 * margin + genscale * depth  + genscale    

    @info("Creating fig with dimesnions w/h $(figwidth) / $(figheight)")
    #fig = Figure(size = (figheight, figwidth ))
    fig = Figure(size = (800, 800 ))
    ax = Axis(fig[1, 1]; title = "Descendants tree")
    
    descendants_points!(fam, gen, ax; orientation = :lr, genscale = 50, margin = 20)

    #=
    for x in xs
        lines!([Point2f(x * genscale, 0), Point2f(x * genscale, figheight)]; color = :blue)
    end
    
    leftborderx = (length(xs)) * genscale
    lines!([Point2f(leftborderx, 0), Point2f(leftborderx, figheight)]; color = :gray)
    rightborderx = -1 * genscale
    lines!([Point2f(rightborderx, 0), Point2f(rightborderx, figheight)]; color = :gray)

    
    husband = individual( husbandid(fam), gen)
    wife = individual(wifeid(fam), gen)

    gen0label = string(name(husband), "\nm.\n", name(wife))
    text!([Point(0, figheight / 2)], text = [gen0label], align = (:right, :center))
=#
    fig
end