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

# ╔═╡ 0d6ac6de-cfee-4b25-ac2f-9ae06ce4ecd6
md"*Use demo file of Presidents?* $(@bind usedemo CheckBox(default=true))"

# ╔═╡ ca028862-5d01-11ed-0e13-01f6b07abf83
f = if usedemo
	joinpath(pwd() |> dirname, "test", "data", "pres2020.ged")
else
	@bind f FilePicker()
end

# ╔═╡ 53668273-179a-4596-97fa-24db84556236
md"""## Ancestors"""

# ╔═╡ b90dd261-5ba5-4fcc-b83f-8babdca51ff4
md"""`GedCom.parents` returns a named tuple with mother and father:"""

# ╔═╡ 39605055-dfea-48ef-863b-3eb83160451a
md"""`FAMC` records:"""

# ╔═╡ dde8e5b0-ce00-4d61-8cb2-8dd27fbc8980
md"""Others in the `FAMC`:"""

# ╔═╡ ecfcad00-ba52-4898-a54f-6cf336ab26d5
md"""`FAMS` records:"""

# ╔═╡ 8bb05b6d-ea18-4aad-b82f-8d4c5cd65869
md"""Others in the `FAMS`:"""

# ╔═╡ 46004ab9-ac76-4817-a4af-54c63c404626
md"""## Descendants"""

# ╔═╡ 5892876a-6ba4-4e2a-9c14-d19aae09f863
md"""A child of an ID has the FAMC family ID that parent has FAMS for."""

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

# ╔═╡ da785287-0cac-41f3-be70-9385eb7956ab
isnothing(gen) ? nothing : GedCom.data(person.records, "FAMC")

# ╔═╡ bfb21b40-dc87-4ad6-9f77-e7e42f4514a1
famsrecc = isnothing(gen) ? nothing : GedCom.data(person.records, "FAMS")

# ╔═╡ e48b20d4-89ed-4e2b-9193-cceca766a04d
if isnothing(gen)
else
	filter(gen.individuals) do ind
		GedCom.data(ind.records, "FAMC") == famsrecc
	end
end

# ╔═╡ c6b1d35f-12ca-4d2e-81de-517011663b19
if isnothing(gen)
else
	filter(gen.individuals) do ind
		GedCom.data(ind.records, "FAMS") == famsrecc
	end
end

# ╔═╡ ebf86867-168e-45d6-b219-96dfea9b932e
mrrgs = GedCom.spouse_families(person)


# ╔═╡ 5b8bb7f6-2b73-467a-ae09-56d9bb1b5ff7
filter(gen.individuals) do ind
	GedCom.data(ind.records, "FAMC") == mrrgs[1]
end

# ╔═╡ 37e7d07e-c955-49c0-a50f-b93819d35a9d
nuclearfamilies = map(mrrgs) do mrg
	GedCom.nuclearfamily(mrg, gen)
end

# ╔═╡ e95f0abd-157a-4180-be8f-c822e0f21fc6
GedCom.children(person, gen)

# ╔═╡ Cell order:
# ╟─bd080239-bf0e-4cfd-8126-aec87a29b908
# ╟─eb702a7e-6a96-47b9-aeb2-46eac03dc561
# ╟─bde8a9a3-71b1-4d0e-8e54-c0616fbe7c3e
# ╟─0d6ac6de-cfee-4b25-ac2f-9ae06ce4ecd6
# ╟─ca028862-5d01-11ed-0e13-01f6b07abf83
# ╟─53668273-179a-4596-97fa-24db84556236
# ╟─d79deaf9-b0e7-4d48-bf8b-4f823848e7d9
# ╟─b90dd261-5ba5-4fcc-b83f-8babdca51ff4
# ╠═1e63fe6d-be8c-43b6-847f-0dc73f3d5657
# ╠═eca70583-735f-4a83-a304-cd9d63a53834
# ╟─39605055-dfea-48ef-863b-3eb83160451a
# ╠═da785287-0cac-41f3-be70-9385eb7956ab
# ╟─dde8e5b0-ce00-4d61-8cb2-8dd27fbc8980
# ╠═e48b20d4-89ed-4e2b-9193-cceca766a04d
# ╟─ecfcad00-ba52-4898-a54f-6cf336ab26d5
# ╠═bfb21b40-dc87-4ad6-9f77-e7e42f4514a1
# ╟─8bb05b6d-ea18-4aad-b82f-8d4c5cd65869
# ╠═c6b1d35f-12ca-4d2e-81de-517011663b19
# ╟─46004ab9-ac76-4817-a4af-54c63c404626
# ╠═ebf86867-168e-45d6-b219-96dfea9b932e
# ╟─5892876a-6ba4-4e2a-9c14-d19aae09f863
# ╠═5b8bb7f6-2b73-467a-ae09-56d9bb1b5ff7
# ╠═e95f0abd-157a-4180-be8f-c822e0f21fc6
# ╠═37e7d07e-c955-49c0-a50f-b93819d35a9d
# ╟─1e7d7661-44aa-468a-af3d-c25864bfd9c1
# ╟─baa3fdf4-b780-406e-bfd5-e5c7e4dc3552
# ╟─be67734a-90a6-4220-926c-39c1d0e89030
# ╠═f9aeeb3a-bfc2-4a15-8f8d-3dae415a4f11
# ╠═83cc665c-3a85-4116-90c4-525780382f2d
# ╠═ca2f6e6e-094f-4a98-a568-2dc858d3fda0
