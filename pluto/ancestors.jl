### A Pluto.jl notebook ###
# v0.19.32

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ bd080239-bf0e-4cfd-8126-aec87a29b908
# ╠═╡ show_logs = false
begin
	using Pkg
	Pkg.add("Revise")
	using Revise
	Pkg.activate(dirname(pwd()))
	using GedCom
	#Pkg.develop("GedCom")
	
	Pkg.add("PlutoUI")
	using PlutoUI
	
	Pkg.add("PlutoTeachingTools")
	using PlutoTeachingTools


	danger(md"""
The organization of this notebook's environment in this cell is  a hack until `GedCom.jl` is  published on juliahub.
""")
end

# ╔═╡ eb702a7e-6a96-47b9-aeb2-46eac03dc561
md"""
# Explore GEDCOM data with `GedCom.jl`
"""

# ╔═╡ bde8a9a3-71b1-4d0e-8e54-c0616fbe7c3e
tip(md"""
## TBD

- add type-ahead filtering of names

""")

# ╔═╡ 83eea2e4-9437-4cc4-acd1-25b4ea335036
md"""## Data set
"""

# ╔═╡ 0d6ac6de-cfee-4b25-ac2f-9ae06ce4ecd6
md"*Use demo file of Presidents?* $(@bind usedemo CheckBox(default=true))"

# ╔═╡ ca028862-5d01-11ed-0e13-01f6b07abf83
f = if usedemo
	joinpath(pwd() |> dirname, "test", "data", "pres2020.ged")
else
	@bind f FilePicker()
end

# ╔═╡ 53668273-179a-4596-97fa-24db84556236
md"""## Individual"""

# ╔═╡ 87ae5c59-cd8e-42d0-8956-6a29efd7678f
md"""### Ancestors"""

# ╔═╡ b90dd261-5ba5-4fcc-b83f-8babdca51ff4
md"""`GedCom.parents` returns a named tuple with mother and father:"""

# ╔═╡ 46004ab9-ac76-4817-a4af-54c63c404626
md"""### Descendants"""

# ╔═╡ 4980e677-ca5e-44a3-87b9-0521e63bffdb
md"""`GedCom.nuclearfamily` returns a list of `NuclearFamily` objects,]
each of which has an ID, a husband (`Individual`), wife (`Individual`) and (possibly empty) list of chilren (`Individual`s)."""

# ╔═╡ 65147a4b-8201-41b4-8d7b-8c13dff99614
md"""### Sources"""

# ╔═╡ 5d595ed3-2739-4bf8-8a4a-9b880b218a9a
md"""### Awesome graph stuff"""

# ╔═╡ 1e7d7661-44aa-468a-af3d-c25864bfd9c1
html"""<br/><br/><br/><br/><br/>"""

# ╔═╡ baa3fdf4-b780-406e-bfd5-e5c7e4dc3552
md"""> Data loading and setup"""

# ╔═╡ be67734a-90a6-4220-926c-39c1d0e89030
# ╠═╡ show_logs = false
gen = if isnothing(f) 
	nothing
elseif isa(f, Dict)
	gcomsrc = f["data"] |> String
	gcomrecords = gedRecords(split(gcomsrc, r"[\n\r]+"))
	Genealogy(GedCom.parseIndividuals(gcomrecords), GedCom.parseFamilies(gcomrecords), GedCom.parseSources(gcomrecords))
	
else
	genealogy(f)
end

# ╔═╡ 5de204f4-a217-4d7d-9a25-aff55e27fc3d
gengraph = GedCom.genealogyGraph(gen)

# ╔═╡ f9aeeb3a-bfc2-4a15-8f8d-3dae415a4f11
sortedpeople = isnothing(gen) ? [] : sort(gen.individuals, by = i -> GedCom.lastname(i) * label(i))

# ╔═╡ 83cc665c-3a85-4116-90c4-525780382f2d
sortedpeople[100] |> label

# ╔═╡ ca2f6e6e-094f-4a98-a568-2dc858d3fda0
namelist = isnothing(gen) ? ["--No file selected--"] : map(sortedpeople) do i	
	(i => GedCom.lastname(i) * ": " * label(i))
end

# ╔═╡ d79deaf9-b0e7-4d48-bf8b-4f823848e7d9
md"""
*Choose a name (unsorted)*:  $(@bind person Select(namelist))
"""


# ╔═╡ 1e63fe6d-be8c-43b6-847f-0dc73f3d5657
if isnothing(gen)
	md""

else
	parentids = GedCom.parents(person,gen)
	if isnothing(parentids)
		md"""Parent family not recorded."""
		
	else
		dad = parentids[:father]
		dadlabel = isnothing(dad) ? "Not recorded" : label(dad)
		mom = parentids[:mother]
		momlabel = isnothing(mom) ? "Not recorded" : label(mom)
		md"""**Parentage of individual $(person.id) $(label(person))**: 
		
		- Father: $(dadlabel)
		- Mother: $(momlabel)
		
		"""
	end
end

# ╔═╡ eca70583-735f-4a83-a304-cd9d63a53834
prnts = isnothing(gen) ? nothing : GedCom.parents(person, gen)

# ╔═╡ b7f5f9ec-99a8-4e22-adeb-cc67f73cd9bf
mrrgs = GedCom.spouse_family_ids(person)

# ╔═╡ 37e7d07e-c955-49c0-a50f-b93819d35a9d
nuclearfamilies = map(mrrgs) do mrg
	GedCom.nuclearfamily(mrg, gen)
end

# ╔═╡ 505be37b-fbc0-4c9c-929e-f2279459feb8
person

# ╔═╡ Cell order:
# ╟─bd080239-bf0e-4cfd-8126-aec87a29b908
# ╟─eb702a7e-6a96-47b9-aeb2-46eac03dc561
# ╟─bde8a9a3-71b1-4d0e-8e54-c0616fbe7c3e
# ╟─83eea2e4-9437-4cc4-acd1-25b4ea335036
# ╟─0d6ac6de-cfee-4b25-ac2f-9ae06ce4ecd6
# ╟─ca028862-5d01-11ed-0e13-01f6b07abf83
# ╟─53668273-179a-4596-97fa-24db84556236
# ╟─d79deaf9-b0e7-4d48-bf8b-4f823848e7d9
# ╟─87ae5c59-cd8e-42d0-8956-6a29efd7678f
# ╟─b90dd261-5ba5-4fcc-b83f-8babdca51ff4
# ╠═1e63fe6d-be8c-43b6-847f-0dc73f3d5657
# ╠═eca70583-735f-4a83-a304-cd9d63a53834
# ╟─46004ab9-ac76-4817-a4af-54c63c404626
# ╠═b7f5f9ec-99a8-4e22-adeb-cc67f73cd9bf
# ╟─4980e677-ca5e-44a3-87b9-0521e63bffdb
# ╠═37e7d07e-c955-49c0-a50f-b93819d35a9d
# ╟─65147a4b-8201-41b4-8d7b-8c13dff99614
# ╠═505be37b-fbc0-4c9c-929e-f2279459feb8
# ╟─5d595ed3-2739-4bf8-8a4a-9b880b218a9a
# ╠═5de204f4-a217-4d7d-9a25-aff55e27fc3d
# ╟─1e7d7661-44aa-468a-af3d-c25864bfd9c1
# ╟─baa3fdf4-b780-406e-bfd5-e5c7e4dc3552
# ╟─be67734a-90a6-4220-926c-39c1d0e89030
# ╠═f9aeeb3a-bfc2-4a15-8f8d-3dae415a4f11
# ╠═83cc665c-3a85-4116-90c4-525780382f2d
# ╠═ca2f6e6e-094f-4a98-a568-2dc858d3fda0
