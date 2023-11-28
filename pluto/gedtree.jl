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


	danger(md"""Until `GedCom.jl` is  published on juliahub, the organization of this notebook's environment in this cell is just a hack dependent on the notebook being located in the `GedCom.jl` repository's `pluto` directory.
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

# ╔═╡ d770b92c-bcf6-4e2f-9b7a-80cbfcd03544
md"""## Nuclear family"""

# ╔═╡ 87ae5c59-cd8e-42d0-8956-6a29efd7678f
md"""### Ancestors"""

# ╔═╡ 46004ab9-ac76-4817-a4af-54c63c404626
md"""### Descendants"""

# ╔═╡ a4b61f2a-4cb0-4f04-bf56-98a79cb1df70
md"""**Marriages**:"""

# ╔═╡ 1e7d7661-44aa-468a-af3d-c25864bfd9c1
html"""<br/><br/><br/><br/><br/>"""

# ╔═╡ d01ab630-7ae6-434f-8b97-bc9b2c788672
md"""
---

*Ignore workings below here*
"""

# ╔═╡ 9a92cea1-e704-4b66-b633-ab24df893881
md"""> Debugging"""

# ╔═╡ 598a6d08-b0a3-42a2-b915-0d7054f4d582
	md"""*Write ancestor mermaid to file:* $(@bind writeanc CheckBox(default = false))"""

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


# ╔═╡ 5dafdd7a-419d-44dd-866d-c3df8b74cf72
isnothing(gen) ? nothing : md"ID: **$(person.id)**"

# ╔═╡ 1e63fe6d-be8c-43b6-847f-0dc73f3d5657
# ╠═╡ show_logs = false
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
		md"""**Parents of $(label(person))**  : 
		
		- Father: $(dadlabel)
		- Mother: $(momlabel)
		
		"""
	end
end

# ╔═╡ c281779b-1576-43cd-9610-bd0aac85f3dc
if isnothing(gen)  
	nothing
else
	mdlist = ["""**Siblings**"""]
	for s in GedCom.siblings(person, gen)
		push!(mdlist, "- " * GedCom.mermaid_tidy(label(s)))
	end
	join(mdlist, "\n") |> Markdown.parse
end

# ╔═╡ 1f999199-70c6-4922-a231-0a260d6cc672
isnothing(gen) ? md"" : md"""**Ancestor tree** for *$(GedCom.label(person))*"""

# ╔═╡ 4416e0cc-918b-4f44-824f-272565cf0ce2
# ╠═╡ show_logs = false
if ! anctree || isnothing(gen)  
	nothing 
else
	mermaid"""$(GedCom.ancestors_mermaid(person, gen, ; flow = ancflow))"""

end

# ╔═╡ 4b91b668-e568-4c23-ac2b-049812851e1a
if isnothing(gen) 
	md""
else
	items = map(mrg -> string("- ", label(mrg)), GedCom.nuclearfamilies(person, gen)) 
	join(items,"\n") |> Markdown.parse
end

# ╔═╡ 5672e14f-17e0-491a-81c1-ba041da42a8b
if ! desctree || isnothing(gen)  
	nothing 
else
	mermaid"""$(GedCom.descendants_mermaid(person, gen ; flow = descflow))"""

end

# ╔═╡ eedb9128-4719-4213-9c91-81871494a0de
isnothing(gen) ? md"" : md"""**Descendant tree** for *$(GedCom.label(person))*"""

# ╔═╡ e9cc00c9-c058-43a7-988b-4d17e976aae0
isnothing(gen) ? md"" : GedCom.descendant_tree_md(person, gen) |> Markdown.parse

# ╔═╡ ee309bd4-22e7-420f-8cfb-b283b2facbfc
if writeanc
	ancmermout = GedCom.ancestors_mermaid(person, gen, ; flow = ancflow)
	open("ancestortree.md", "w") do io
		write(io, ancmermout)
	end
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
# ╟─5dafdd7a-419d-44dd-866d-c3df8b74cf72
# ╟─d770b92c-bcf6-4e2f-9b7a-80cbfcd03544
# ╟─1e63fe6d-be8c-43b6-847f-0dc73f3d5657
# ╟─c281779b-1576-43cd-9610-bd0aac85f3dc
# ╟─87ae5c59-cd8e-42d0-8956-6a29efd7678f
# ╟─1f999199-70c6-4922-a231-0a260d6cc672
# ╟─6ea487fe-dc46-4d52-93a9-43cae36ace53
# ╟─4416e0cc-918b-4f44-824f-272565cf0ce2
# ╟─46004ab9-ac76-4817-a4af-54c63c404626
# ╟─a4b61f2a-4cb0-4f04-bf56-98a79cb1df70
# ╟─4b91b668-e568-4c23-ac2b-049812851e1a
# ╟─e45d9aae-edd3-4604-87ed-9a63a5e94f45
# ╟─5672e14f-17e0-491a-81c1-ba041da42a8b
# ╟─eedb9128-4719-4213-9c91-81871494a0de
# ╟─e9cc00c9-c058-43a7-988b-4d17e976aae0
# ╟─1e7d7661-44aa-468a-af3d-c25864bfd9c1
# ╟─d01ab630-7ae6-434f-8b97-bc9b2c788672
# ╟─9a92cea1-e704-4b66-b633-ab24df893881
# ╟─598a6d08-b0a3-42a2-b915-0d7054f4d582
# ╟─ee309bd4-22e7-420f-8cfb-b283b2facbfc
# ╟─47e70316-05b9-42c2-a865-bdef21899116
# ╟─6fe93cfa-747a-4142-9891-6b75ee0d2db2
# ╟─479bca88-a413-43b3-b552-edbea4b1c40b
# ╟─baa3fdf4-b780-406e-bfd5-e5c7e4dc3552
# ╟─be67734a-90a6-4220-926c-39c1d0e89030
# ╠═f9aeeb3a-bfc2-4a15-8f8d-3dae415a4f11
# ╠═ca2f6e6e-094f-4a98-a568-2dc858d3fda0
