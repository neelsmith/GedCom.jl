

function descendants_plot(fam::FamilyUnit, gen::Genealogy; orientation = :lr, genscale = 50, margin = 20)
    dimensionsdict = descendants_dimensions(fam, gen)
    ys = values(dimensionsdict) |> collect 
    ht = ys |> maximum 
    figheight = 2 * margin +  ht * genscale


    xs = keys(dimensionsdict) |>  collect |> sort
    genwdth = xs |> maximum
    figwidth = 2* margin + genscale * length(xs)  + genscale
    

    fig = Figure(size = (figheight, figwidth ))
    ax = Axis(fig[1, 1]; title = "Descendants tree")

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

    fig
end