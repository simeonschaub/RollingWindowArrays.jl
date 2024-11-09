@testitem "DimensionalData integration" begin
    using DimensionalData, Statistics

    x = DimArray(rand(10, 10), (X(0:9), Ti(2001:2010)))
    y = rolling(x, 2, 2; dims = X)
    # :)
    @test y isa DimArray{DimMatrix{Float64, Tuple{X{DimensionalData.Dimensions.Lookups.Sampled{Int64, UnitRange{Int64}, DimensionalData.Dimensions.Lookups.ForwardOrdered, DimensionalData.Dimensions.Lookups.Regular{Int64}, DimensionalData.Dimensions.Lookups.Points, DimensionalData.Dimensions.Lookups.NoMetadata}}, Ti{DimensionalData.Dimensions.Lookups.Sampled{Int64, UnitRange{Int64}, DimensionalData.Dimensions.Lookups.ForwardOrdered, DimensionalData.Dimensions.Lookups.Regular{Int64}, DimensionalData.Dimensions.Lookups.Points, DimensionalData.Dimensions.Lookups.NoMetadata}}}, Tuple{}, SubArray{Float64, 2, Matrix{Float64}, Tuple{UnitRange{Int64}, Base.Slice{Base.OneTo{Int64}}}, false}, DimensionalData.NoName, DimensionalData.Dimensions.Lookups.NoMetadata}, 1}
    @test length(y) == 6
    @test y == rolling(x, 5; center = true, dims = X)

    @test mean.(y; dims = X) isa DimArray{DimMatrix{Float64, Tuple{X{DimensionalData.Dimensions.Lookups.Sampled{Float64, StepRangeLen{Float64, Base.TwicePrecision{Float64}, Base.TwicePrecision{Float64}, Int64}, DimensionalData.Dimensions.Lookups.ForwardOrdered, DimensionalData.Dimensions.Lookups.Regular{Float64}, DimensionalData.Dimensions.Lookups.Points, DimensionalData.Dimensions.Lookups.NoMetadata}}, Ti{DimensionalData.Dimensions.Lookups.Sampled{Int64, UnitRange{Int64}, DimensionalData.Dimensions.Lookups.ForwardOrdered, DimensionalData.Dimensions.Lookups.Regular{Int64}, DimensionalData.Dimensions.Lookups.Points, DimensionalData.Dimensions.Lookups.NoMetadata}}}, Tuple{}, Matrix{Float64}, DimensionalData.NoName, DimensionalData.Dimensions.Lookups.NoMetadata}, 1}

    z = rolling(DimArray(rand(10), Ti(1001:1010)), 2, 2)
    @test z isa DimArray{DimVector{Float64, Tuple{Ti{DimensionalData.Dimensions.Lookups.Sampled{Int64, UnitRange{Int64}, DimensionalData.Dimensions.Lookups.ForwardOrdered, DimensionalData.Dimensions.Lookups.Regular{Int64}, DimensionalData.Dimensions.Lookups.Points, DimensionalData.Dimensions.Lookups.NoMetadata}}}, Tuple{}, SubArray{Float64, 1, Vector{Float64}, Tuple{UnitRange{Int64}}, true}, DimensionalData.NoName, DimensionalData.Dimensions.Lookups.NoMetadata}, 1}
end
