# RollingWindowArrays

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://simeonschaub.github.io/RollingWindowArrays.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://simeonschaub.github.io/RollingWindowArrays.jl/dev/)
[![Build Status](https://github.com/simeonschaub/RollingWindowArrays.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/simeonschaub/RollingWindowArrays.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/simeonschaub/RollingWindowArrays.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/simeonschaub/RollingWindowArrays.jl)

RollingWindowArrays.jl provides a `RollingWindowVector` type that allows you to efficiently compute
rolling window operations on arrays. This is useful for tasks such as computing moving averages,
rolling standard deviations, or other rolling window operations.

The function `rolling` is used to create a `RollingWindowVector` of given window size from an array:

```julia-repl
julia> using RollingWindowArrays

julia> x = rand(10)
10-element Vector{Float64}:
 0.937836651304297
 0.11322685640037888
 0.09331671858295698
 0.927724621490372
 0.6521726277956932
 0.4921780012050869
 0.5873327705770311
 0.7347864656422705
 0.08155772884167745
 0.7495245577517846

julia> rolling(x, 3)
8-element RollingWindowArrays.RollingWindowVector{SubArray{Float64, 1, Vector{Float64}, Tuple{UnitRange{Int64}}, true}, Vector{Float64}} with indices 1:8:
 [0.937836651304297, 0.11322685640037888, 0.09331671858295698]
 [0.11322685640037888, 0.09331671858295698, 0.927724621490372]
 [0.09331671858295698, 0.927724621490372, 0.6521726277956932]
 [0.927724621490372, 0.6521726277956932, 0.4921780012050869]
 [0.6521726277956932, 0.4921780012050869, 0.5873327705770311]
 [0.4921780012050869, 0.5873327705770311, 0.7347864656422705]
 [0.5873327705770311, 0.7347864656422705, 0.08155772884167745]
 [0.7347864656422705, 0.08155772884167745, 0.7495245577517846]
 ```

 The `center` keyword argument can be used to specify whether the window should be centered around the
 current element, affecting the axes of the resulting `RollingWindowVector` (notice how the indices
 are now `2:9` instead of `1:8`):

 ```julia-repl
julia> rolling(x, 3; center=true)
8-element RollingWindowArrays.RollingWindowVector{SubArray{Float64, 1, Vector{Float64}, Tuple{UnitRange{Int64}}, true}, Vector{Float64}} with indices 2:9:
 [0.937836651304297, 0.11322685640037888, 0.09331671858295698]
 [0.11322685640037888, 0.09331671858295698, 0.927724621490372]
 [0.09331671858295698, 0.927724621490372, 0.6521726277956932]
 [0.927724621490372, 0.6521726277956932, 0.4921780012050869]
 [0.6521726277956932, 0.4921780012050869, 0.5873327705770311]
 [0.4921780012050869, 0.5873327705770311, 0.7347864656422705]
 [0.5873327705770311, 0.7347864656422705, 0.08155772884167745]
 [0.7347864656422705, 0.08155772884167745, 0.7495245577517846]
 ```

 This is especially useful for the DimensionalData.jl integration, where `rolling` has special
 support for `DimArray`s:

 ```julia-repl
julia> using DimensionalData

julia> x = DimArray(rand(10), Ti(2015:2024))
╭────────────────────────────────╮
│ 10-element DimArray{Float64,1} │
├────────────────────────────────┴────────────────────────────────────────────────────────────────────────────────────────────────────────── dims ┐
  ↓ Ti Sampled{Int64} 2015:2024 ForwardOrdered Regular Points
└─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
 2015  0.102453
 2016  0.761745
 2017  0.599038
 2018  0.71073
 2019  0.725253
 2020  0.855213
 2021  0.40338
 2022  0.658587
 2023  0.783249
 2024  0.116619

julia> rolling(x, 3; center = true)
╭──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
│ 8-element DimArray{DimVector{Float64, Tuple{Ti{DimensionalData.Dimensions.Lookups.Sampled{Int64, UnitRange{Int64}, DimensionalData.Dimensions.Lookups.ForwardOrdered, DimensionalData.Dimensions.Lookups.Regular{Int64}, DimensionalData.Dimensions.Lookups.Points, DimensionalData.Dimensions.Lookups.NoMetadata}}}, Tuple{}, SubArray{Float64, 1, Vector{Float64}, Tuple{UnitRange{Int64}}, true}, DimensionalData.NoName, DimensionalData.Dimensions.Lookups.NoMetadata},1} │
├──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────── dims ┤
  ↓ Ti Sampled{Int64} OffsetArrays.IdOffsetRange(values=2016:2023, indices=2:9) ForwardOrdered Regular Points
└──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
 2016  [0.102453, 0.761745, 0.599038]
 2017  [0.761745, 0.599038, 0.71073]
 2018  [0.599038, 0.71073, 0.725253]
 2019  [0.71073, 0.725253, 0.855213]
 2020  [0.725253, 0.855213, 0.40338]
 2021  [0.855213, 0.40338, 0.658587]
 2022  [0.40338, 0.658587, 0.783249]
 2023  [0.658587, 0.783249, 0.116619]
 ```

This can then be used to create a rolling 3-year mean for example, by simply using broadcasting:

```julia-repl
julia> using Statistics

julia> mean.(rolling(x, 3; center = true))
╭───────────────────────────────╮
│ 8-element DimArray{Float64,1} │
├───────────────────────────────┴─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────── dims ┐
  ↓ Ti Sampled{Int64} OffsetArrays.IdOffsetRange(values=2016:2023, indices=2:9) ForwardOrdered Regular Points
└─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
 2016  0.487745
 2017  0.690504
 2018  0.67834
 2019  0.763732
 2020  0.661282
 2021  0.63906
 2022  0.615072
 2023  0.519485
 ```

 Creating rolling windows over mulidimensional arrays is also supported through the `dims` keyword:

 ```julia-repl
 julia> grid = DimArray(rand(3, 3, 10), (X(-1:1), Y(-1:1), Ti(2015:2024)))
╭────────────────────────────╮
│ 3×3×10 DimArray{Float64,3} │
├────────────────────────────┴─────────────────────────────────────────────────────────────────────────────────────────────────────────── dims ┐
  ↓ X  Sampled{Int64} -1:1 ForwardOrdered Regular Points,
  → Y  Sampled{Int64} -1:1 ForwardOrdered Regular Points,
  ↗ Ti Sampled{Int64} 2015:2024 ForwardOrdered Regular Points
└──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
[:, :, 1]
  ↓ →  -1         0          1
 -1     0.560702  0.579703   0.934467
  0     0.717332  0.0432167  0.703719
  1     0.112182  0.887698   0.114744

julia> grid_3y_mean = mean.(rolling(grid, 3; center = true, dims = Ti))
╭──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
│ 8-element DimArray{DimMatrix{Float64, Tuple{X{DimensionalData.Dimensions.Lookups.Sampled{Int64, UnitRange{Int64}, DimensionalData.Dimensions.Lookups.ForwardOrdered, DimensionalData.Dimensions.Lookups.Regular{Int64}, DimensionalData.Dimensions.Lookups.Points, DimensionalData.Dimensions.Lookups.NoMetadata}}, Y{DimensionalData.Dimensions.Lookups.Sampled{Int64, UnitRange{Int64}, DimensionalData.Dimensions.Lookups.ForwardOrdered, DimensionalData.Dimensions.Lookups.Regular{Int64}, DimensionalData.Dimensions.Lookups.Points, DimensionalData.Dimensions.Lookups.NoMetadata}}}, Tuple{Ti{DimensionalData.Dimensions.Lookups.Sampled{Int64, UnitRange{Int64}, DimensionalData.Dimensions.Lookups.ForwardOrdered, DimensionalData.Dimensions.Lookups.Regular{Int64}, DimensionalData.Dimensions.Lookups.Points, DimensionalData.Dimensions.Lookups.NoMetadata}}}, Matrix{Float64}, Symbol, DimensionalData.Dimensions.Lookups.NoMetadata},1} │
├──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────── dims ┤
  ↓ Ti Sampled{Int64} OffsetArrays.IdOffsetRange(values=2016:2023, indices=2:9) ForwardOrdered Regular Points
└──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
 2016  [0.660477 0.606111 0.904461; 0.477301 0.199695 0.570025; 0.229291 0.822954 0.247316]
 2017  [0.60767 0.659907 0.663222; 0.569647 0.321259 0.535692; 0.201556 0.672966 0.513897]
 2018  [0.542124 0.482802 0.679658; 0.452112 0.437849 0.346133; 0.442013 0.567182 0.549251]
 2019  [0.385936 0.663915 0.421112; 0.717 0.548997 0.392006; 0.496606 0.622743 0.722243]
 2020  [0.262313 0.627445 0.467072; 0.404598 0.640368 0.251814; 0.807042 0.655714 0.645392]
 2021  [0.152767 0.739649 0.18593; 0.569159 0.538198 0.473967; 0.826602 0.628676 0.485242]
 2022  [0.176324 0.491431 0.215837; 0.37002 0.540087 0.528695; 0.708786 0.522197 0.489434]
 2023  [0.218819 0.395397 0.110994; 0.67808 0.50034 0.668674; 0.715467 0.501929 0.406186]

julia> stack(grid_3y_mean)[X = At(0), Y = At(0)]
╭───────────────────────────────╮
│ 8-element DimArray{Float64,1} │
├───────────────────────────────┴─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────── dims ┐
  ↓ Ti Sampled{Int64} OffsetArrays.IdOffsetRange(values=2016:2023, indices=2:9) ForwardOrdered Regular Points
└─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
 2016  0.199695
 2017  0.321259
 2018  0.437849
 2019  0.548997
 2020  0.640368
 2021  0.538198
 2022  0.540087
 2023  0.50034
 ```
