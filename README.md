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
 0.5641112488276627
 0.22120012232070818
 0.3679067902780746
 0.5623875869261128
 0.6440904700394701
 0.247718935392934
 0.24983687211882766
 0.4477721985453925
 0.5929269441970979
 0.3541576787013937

julia> rolling(x, 3)
8-element RollingWindowArrays.RollingWindowVector{SubArray{Float64, 1, Vector{Float64}, Tuple{UnitRange{Int64}}, true}, Vector{Float64}, 1} with indices 1:8:
 [0.5641112488276627, 0.22120012232070818, 0.3679067902780746]
 [0.22120012232070818, 0.3679067902780746, 0.5623875869261128]
 [0.3679067902780746, 0.5623875869261128, 0.6440904700394701]
 [0.5623875869261128, 0.6440904700394701, 0.247718935392934]
 [0.6440904700394701, 0.247718935392934, 0.24983687211882766]
 [0.247718935392934, 0.24983687211882766, 0.4477721985453925]
 [0.24983687211882766, 0.4477721985453925, 0.5929269441970979]
 [0.4477721985453925, 0.5929269441970979, 0.3541576787013937]
 ```

 The `center` keyword argument can be used to specify whether the window should be centered around the
 current element, affecting the axes of the resulting `RollingWindowVector` (notice how the indices
 are now `2:9` instead of `1:8`):

 ```julia-repl
julia> rolling(x, 3; center=true)
8-element RollingWindowArrays.RollingWindowVector{SubArray{Float64, 1, Vector{Float64}, Tuple{UnitRange{Int64}}, true}, Vector{Float64}, 1} with indices 2:9:
 [0.5641112488276627, 0.22120012232070818, 0.3679067902780746]
 [0.22120012232070818, 0.3679067902780746, 0.5623875869261128]
 [0.3679067902780746, 0.5623875869261128, 0.6440904700394701]
 [0.5623875869261128, 0.6440904700394701, 0.247718935392934]
 [0.6440904700394701, 0.247718935392934, 0.24983687211882766]
 [0.247718935392934, 0.24983687211882766, 0.4477721985453925]
 [0.24983687211882766, 0.4477721985453925, 0.5929269441970979]
 [0.4477721985453925, 0.5929269441970979, 0.3541576787013937]
 ```

 This is especially useful for the DimensionalData.jl integration, where `rolling` has special
 support for `DimArray`s:

 ```julia-repl
 julia> x = DimArray(rand(10), Ti(2015:2024))
╭────────────────────────────────╮
│ 10-element DimArray{Float64,1} │
├────────────────────────────────┴────────────────────────────────────────────────────────────────────────────────────────────────────────── dims ┐
  ↓ Ti Sampled{Int64} 2015:2024 ForwardOrdered Regular Points
└─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
 2015  0.395081
 2016  0.362025
 2017  0.178012
 2018  0.81853
 2019  0.538458
 2020  0.203418
 2021  0.433708
 2022  0.649627
 2023  0.901228
 2024  0.712791

julia> rolling(x, 3; center = true)
╭─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
│ 8-element DimArray{DimVector{Float64, Tuple{Ti{DimensionalData.Dimensions.Lookups.Sampled{Int64, UnitRange{Int64}, DimensionalData.Dimensions.Lookups.ForwardOrdered, DimensionalData.Dimensions.Lookups.Regular{Int64}, DimensionalData.Dimensions.Lookups.Points, DimensionalData.Dimensions.Lookups.NoMetadata}}}, Tuple{}, SubArray{Float64, 1, Vector{Float64}, Tuple{UnitRange{Int64}}, true}, DimensionalData.NoName, DimensionalData.Dimensions.Lookups.NoMetadata},1} │
├─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────── dims ┤
  ↓ Ti Sampled{Int64} OffsetArrays.IdOffsetRange(values=2016:2023, indices=2:9) ForwardOrdered Regular Points
└─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
 2016  [0.395081, 0.362025, 0.178012]
 2017  [0.362025, 0.178012, 0.81853]
 2018  [0.178012, 0.81853, 0.538458]
 2019  [0.81853, 0.538458, 0.203418]
 2020  [0.538458, 0.203418, 0.433708]
 2021  [0.203418, 0.433708, 0.649627]
 2022  [0.433708, 0.649627, 0.901228]
 2023  [0.649627, 0.901228, 0.712791]
 ```

This can then be used to create a rolling 3-year mean for example, by simply using broadcasting:

```julia-repl
julia> using Statistics

julia> mean.(rolling(x, 3; center = true))
╭───────────────────────────────╮
│ 8-element DimArray{Float64,1} │
├───────────────────────────────┴─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────── dims ┐
  ↓ Ti Sampled{Int64} OffsetArrays.IdOffsetRange(values=2016:2023, indices=2:9) ForwardOrdered Regular Points
└─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
 2016  0.311706
 2017  0.452856
 2018  0.511667
 2019  0.520135
 2020  0.391861
 2021  0.428917
 2022  0.661521
 2023  0.754549
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
 -1     0.21157   0.645023   0.537563
  0     0.596212  0.423664   0.451312
  1     0.893659  0.0941666  0.0751371

julia> grid_3y_mean = dropdims.(mean.(rolling(grid, 3; center = true, dims = Ti); dims = Ti); dims = Ti)
╭─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
│ 8-element DimArray{DimMatrix{Float64, Tuple{X{DimensionalData.Dimensions.Lookups.Sampled{Int64, UnitRange{Int64}, DimensionalData.Dimensions.Lookups.ForwardOrdered, DimensionalData.Dimensions.Lookups.Regular{Int64}, DimensionalData.Dimensions.Lookups.Points, DimensionalData.Dimensions.Lookups.NoMetadata}}, Y{DimensionalData.Dimensions.Lookups.Sampled{Int64, UnitRange{Int64}, DimensionalData.Dimensions.Lookups.ForwardOrdered, DimensionalData.Dimensions.Lookups.Regular{Int64}, DimensionalData.Dimensions.Lookups.Points, DimensionalData.Dimensions.Lookups.NoMetadata}}}, Tuple{Ti{DimensionalData.Dimensions.Lookups.Sampled{Float64, StepRangeLen{Float64, Base.TwicePrecision{Float64}, Base.TwicePrecision{Float64}, Int64}, DimensionalData.Dimensions.Lookups.ForwardOrdered, DimensionalData.Dimensions.Lookups.Regular{Float64}, DimensionalData.Dimensions.Lookups.Points, DimensionalData.Dimensions.Lookups.NoMetadata}}}, Matrix{Float64}, DimensionalData.NoName, DimensionalData.Dimensions.Lookups.NoMetadata},1} │
├─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────── dims ┤
  ↓ Ti Sampled{Int64} OffsetArrays.IdOffsetRange(values=2016:2023, indices=2:9) ForwardOrdered Regular Points
└─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
 2016  [0.612901 0.612267 0.685449; 0.474032 0.773932 0.450534; 0.310023 0.469109 0.342738]
 2017  [0.834115 0.692197 0.506474; 0.525868 0.761104 0.603797; 0.132387 0.767909 0.458608]
 2018  [0.815439 0.589489 0.562757; 0.479255 0.701758 0.345831; 0.210421 0.585885 0.64285]
 2019  [0.632451 0.483513 0.485063; 0.350861 0.537574 0.369789; 0.41726 0.516414 0.535672]
 2020  [0.389338 0.323465 0.541948; 0.270706 0.52332 0.173777; 0.505959 0.389705 0.716001]
 2021  [0.176405 0.484392 0.471247; 0.217172 0.496473 0.40988; 0.545246 0.572485 0.55958]
 2022  [0.389112 0.682227 0.321591; 0.490578 0.364561 0.629233; 0.383283 0.555528 0.56231]
 2023  [0.672318 0.627305 0.416213; 0.343098 0.399091 0.679177; 0.443748 0.421359 0.504259]

julia> stack(grid_3y_mean)
╭───────────────────────────╮
│ 3×3×8 DimArray{Float64,3} │
├───────────────────────────┴─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────── dims ┐
  ↓ X  Sampled{Int64} -1:1 ForwardOrdered Regular Points,
  → Y  Sampled{Int64} -1:1 ForwardOrdered Regular Points,
  ↗ Ti Sampled{Int64} OffsetArrays.IdOffsetRange(values=2016:2023, indices=2:9) ForwardOrdered Regular Points
└─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
[:, :, 2]
  ↓ →  -1         0         1
 -1     0.612901  0.612267  0.685449
  0     0.474032  0.773932  0.450534
  1     0.310023  0.469109  0.342738
 ```
