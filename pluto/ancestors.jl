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

	Pkg.add("Kroki")
	using Kroki


	danger(md"""
The organization of this notebook's environment in this cell is a hack until `GedCom.jl` is  published on juliahub.
""")
end

# ╔═╡ d5a79c00-1d0b-4df0-98c2-fa0c4d385475
md"""# GED tree"""

# ╔═╡ eb702a7e-6a96-47b9-aeb2-46eac03dc561
md"""
> *Explore family relations recorded in a GEDCOM data source.*"""

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

# ╔═╡ 598a6d08-b0a3-42a2-b915-0d7054f4d582
md"""*Write ancestor mermaid to file:* $(@bind writeanc CheckBox())"""

# ╔═╡ cef20de7-3e9c-4683-b925-73a56c5e7b09
md"""### Marriages"""

# ╔═╡ 46004ab9-ac76-4817-a4af-54c63c404626
md"""### Descendants"""

# ╔═╡ 1e7d7661-44aa-468a-af3d-c25864bfd9c1
html"""<br/><br/><br/><br/><br/>"""

# ╔═╡ 47e70316-05b9-42c2-a865-bdef21899116
md"""> UI"""

# ╔═╡ 6fe93cfa-747a-4142-9891-6b75ee0d2db2
ancflowmenu = [
"LR" => "left to right",
"RL" => "right to left",
"BT" => "bottom to top",
"TB" => "top to bottom",
]

# ╔═╡ 6ea487fe-dc46-4d52-93a9-43cae36ace53
md"""*Plot ancestor tree*: $(@bind anctree CheckBox(default = true)) *Orientation*: $(@bind ancflow Select(ancflowmenu))"""

# ╔═╡ 479bca88-a413-43b3-b552-edbea4b1c40b
descflowmenu = [
"TB" => "top to bottom",
"LR" => "left to right"
]

# ╔═╡ e45d9aae-edd3-4604-87ed-9a63a5e94f45
md"""*Plot descendant tree*: $(@bind desctree CheckBox(default = true)) *Orientation*: $(@bind descflow Select(descflowmenu))"""

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

# ╔═╡ f9aeeb3a-bfc2-4a15-8f8d-3dae415a4f11
sortedpeople = isnothing(gen) ? [] : sort(gen.individuals, by = i -> GedCom.lastname(i) * label(i))

# ╔═╡ 2272b18a-c033-4779-a1fa-1920a48cf9b9
md"""*Data set with* **$(length(sortedpeople)) individuals**"""

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
		md"""**Parents of individual $(person.id) $(label(person))**: 
		
		- Father: $(dadlabel)
		- Mother: $(momlabel)
		
		"""
	end
end

# ╔═╡ c281779b-1576-43cd-9610-bd0aac85f3dc
isnothing(gen) ? nothing : GedCom.siblings(person, gen)

# ╔═╡ 1f999199-70c6-4922-a231-0a260d6cc672
isnothing(gen) ? md"" : md"""**Ancestor tree** for *$(GedCom.label(person))*"""

# ╔═╡ 4416e0cc-918b-4f44-824f-272565cf0ce2
if ! anctree || isnothing(gen)  
	nothing 
else
	mermaid"""$(GedCom.ancestors_mermaid(person, gen, ; flow = ancflow))"""

end

# ╔═╡ ee309bd4-22e7-420f-8cfb-b283b2facbfc
if writeanc
	ancmermout = GedCom.ancestors_mermaid(person, gen, ; flow = ancflow)
	open("ancestortree.md", "w") do io
		write(io, ancmermout)
	end
end


# ╔═╡ 4b91b668-e568-4c23-ac2b-049812851e1a
if isnothing(gen) 
	md""
else
	items = map(mrg -> string("- ", label(mrg)), GedCom.nuclearfamilies(person, gen)) 
	join(items,"\n") |> Markdown.parse
end

# ╔═╡ eedb9128-4719-4213-9c91-81871494a0de
isnothing(gen) ? md"" : md"""**Descendant tree** for *$(GedCom.label(person))*"""

# ╔═╡ e9cc00c9-c058-43a7-988b-4d17e976aae0
isnothing(gen) ? md"" : GedCom.descendant_tree_md(person, gen) |> Markdown.parse

# ╔═╡ 5672e14f-17e0-491a-81c1-ba041da42a8b
if ! desctree || isnothing(gen)  
	nothing 
else
	mermaid"""$(GedCom.descendants_mermaid(person, gen, ; flow = descflow))"""

end

# ╔═╡ Cell order:
# ╟─bd080239-bf0e-4cfd-8126-aec87a29b908
# ╟─d5a79c00-1d0b-4df0-98c2-fa0c4d385475
# ╟─eb702a7e-6a96-47b9-aeb2-46eac03dc561
# ╟─83eea2e4-9437-4cc4-acd1-25b4ea335036
# ╟─0d6ac6de-cfee-4b25-ac2f-9ae06ce4ecd6
# ╟─ca028862-5d01-11ed-0e13-01f6b07abf83
# ╟─2272b18a-c033-4779-a1fa-1920a48cf9b9
# ╟─53668273-179a-4596-97fa-24db84556236
# ╟─d79deaf9-b0e7-4d48-bf8b-4f823848e7d9
# ╟─87ae5c59-cd8e-42d0-8956-6a29efd7678f
# ╟─b90dd261-5ba5-4fcc-b83f-8babdca51ff4
# ╟─1e63fe6d-be8c-43b6-847f-0dc73f3d5657
# ╠═c281779b-1576-43cd-9610-bd0aac85f3dc
# ╟─1f999199-70c6-4922-a231-0a260d6cc672
# ╟─6ea487fe-dc46-4d52-93a9-43cae36ace53
# ╠═4416e0cc-918b-4f44-824f-272565cf0ce2
# ╟─598a6d08-b0a3-42a2-b915-0d7054f4d582
# ╟─ee309bd4-22e7-420f-8cfb-b283b2facbfc
# ╟─cef20de7-3e9c-4683-b925-73a56c5e7b09
# ╟─4b91b668-e568-4c23-ac2b-049812851e1a
# ╟─46004ab9-ac76-4817-a4af-54c63c404626
# ╟─eedb9128-4719-4213-9c91-81871494a0de
# ╟─e9cc00c9-c058-43a7-988b-4d17e976aae0
# ╟─e45d9aae-edd3-4604-87ed-9a63a5e94f45
# ╟─5672e14f-17e0-491a-81c1-ba041da42a8b
# ╟─1e7d7661-44aa-468a-af3d-c25864bfd9c1
# ╟─47e70316-05b9-42c2-a865-bdef21899116
# ╟─6fe93cfa-747a-4142-9891-6b75ee0d2db2
# ╟─479bca88-a413-43b3-b552-edbea4b1c40b
# ╟─baa3fdf4-b780-406e-bfd5-e5c7e4dc3552
# ╟─be67734a-90a6-4220-926c-39c1d0e89030
# ╠═f9aeeb3a-bfc2-4a15-8f8d-3dae415a4f11
# ╠═ca2f6e6e-094f-4a98-a568-2dc858d3fda0
