# Coulter

[![Build Status](https://travis-ci.org/tlnagy/Coulter.jl.svg?branch=master)](https://travis-ci.org/tlnagy/Coulter.jl) [![Coverage Status](https://coveralls.io/repos/tlnagy/Coulter.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/tlnagy/Coulter.jl?branch=master) [![codecov.io](http://codecov.io/github/tlnagy/Coulter.jl/coverage.svg?branch=master)](http://codecov.io/github/tlnagy/Coulter.jl?branch=master)

Interfacing with Beckman-Coulter Multisizer/Z2 Coulter Counter files (.#=Z2, etc) in Julia

## Usage

Run the following in the Julia REPL

```julia
Pkg.clone("https://github.com/tlnagy/Coulter.jl.git")
```

To use the package do the following

```julia
using Coulter
loadZ2("path to file here.#=Z2")
```
