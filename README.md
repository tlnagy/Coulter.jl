# Coulter

![](https://juliahub.com/docs/Coulter/version.svg) [![][status-img]][status-url] [![][ci-img]][ci-url] [![][codecov-img]][codecov-url]

Interfacing with Beckman-Coulter Multisizer/Z2 Coulter Counter files (.#=Z2, etc) in Julia

## Usage

Run the following in the Julia REPL

```julia
using Pkg
Pkg.add("Coulter")
```

To use the package do the following

```julia
using Coulter
loadZ2("path to file here.#=Z2", "sample name")
```

[ci-img]: https://github.com/tlnagy/Coulter.jl/workflows/CI/badge.svg
[ci-url]: https://github.com/tlnagy/Coulter.jl/actions

[codecov-img]: https://codecov.io/gh/tlnagy/Coulter.jl/branch/master/graph/badge.svg
[codecov-url]: https://codecov.io/gh/tlnagy/Coulter.jl

[status-img]: https://www.repostatus.org/badges/latest/inactive.svg
[status-url]: https://www.repostatus.org/#inactive