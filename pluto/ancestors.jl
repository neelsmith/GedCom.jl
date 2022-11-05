### A Pluto.jl notebook ###
# v0.19.13

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
begin
	using Pkg
	Pkg.activate(dirname(pwd()))
	using GedCom
	using PlutoUI
end

# ╔═╡ eb702a7e-6a96-47b9-aeb2-46eac03dc561
md"""
# `GedCom.jl`: ancestry trees
"""

# ╔═╡ 06e9ba77-502a-45d8-9f95-11129db03606
md"""
> The organization of this notebook's environment (in the following cell) is  a hack until `GedCom.jl` is  published on juliahub.
"""

# ╔═╡ bde8a9a3-71b1-4d0e-8e54-c0616fbe7c3e
md"""
## TBD

- add type-ahead filtering of names

"""

# ╔═╡ eebaf68e-e39c-4e41-846f-49cc8e5f830c
md"""
## About the dataset
"""

# ╔═╡ 53668273-179a-4596-97fa-24db84556236
md"""## Ancestry trees"""

# ╔═╡ 1e7d7661-44aa-468a-af3d-c25864bfd9c1
html"""<br/><br/><br/><br/><br/>"""

# ╔═╡ baa3fdf4-b780-406e-bfd5-e5c7e4dc3552
md"""> Data loading and setup"""

# ╔═╡ ca028862-5d01-11ed-0e13-01f6b07abf83
f = joinpath(pwd() |> dirname, "test", "data", "pres2020.ged")

# ╔═╡ be67734a-90a6-4220-926c-39c1d0e89030
# ╠═╡ show_logs = false
gen = genealogy(f)

# ╔═╡ f9aeeb3a-bfc2-4a15-8f8d-3dae415a4f11
sortedpeople = sort(gen.individuals, by = i -> GedCom.lastname(i))

# ╔═╡ ca2f6e6e-094f-4a98-a568-2dc858d3fda0
namelist = map(sortedpeople) do i	
	(i => label(i))
end

# ╔═╡ d79deaf9-b0e7-4d48-bf8b-4f823848e7d9
md"""
*Choose a name (unsorted)*:  $(@bind person Select(namelist))
"""

# ╔═╡ 1e63fe6d-be8c-43b6-847f-0dc73f3d5657
md"""**Parentage function**:  $(GedCom.parentage(person, gen))
"""

# ╔═╡ ac727aa5-6b4e-4743-9dd5-9cc390a60632
md"""**Parents function**:  $(GedCom.parents(person, gen))
"""

# ╔═╡ Cell order:
# ╟─eb702a7e-6a96-47b9-aeb2-46eac03dc561
# ╟─06e9ba77-502a-45d8-9f95-11129db03606
# ╟─bd080239-bf0e-4cfd-8126-aec87a29b908
# ╟─bde8a9a3-71b1-4d0e-8e54-c0616fbe7c3e
# ╟─eebaf68e-e39c-4e41-846f-49cc8e5f830c
# ╟─53668273-179a-4596-97fa-24db84556236
# ╟─d79deaf9-b0e7-4d48-bf8b-4f823848e7d9
# ╟─1e63fe6d-be8c-43b6-847f-0dc73f3d5657
# ╟─ac727aa5-6b4e-4743-9dd5-9cc390a60632
# ╟─1e7d7661-44aa-468a-af3d-c25864bfd9c1
# ╟─baa3fdf4-b780-406e-bfd5-e5c7e4dc3552
# ╟─be67734a-90a6-4220-926c-39c1d0e89030
# ╟─ca028862-5d01-11ed-0e13-01f6b07abf83
# ╠═f9aeeb3a-bfc2-4a15-8f8d-3dae415a4f11
# ╠═ca2f6e6e-094f-4a98-a568-2dc858d3fda0
