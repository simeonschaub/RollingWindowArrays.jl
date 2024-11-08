@testitem "core functionality" begin
    using Statistics, OffsetArrays

    x = rand(10, 10)
    y = rolling(x, 2, 2; dims=2)
    # :)
    @test y isa MovingWindowArrays.MovingWindowVector{SubArray{SubArray{Float64, 1, Matrix{Float64}, Tuple{Base.Slice{Base.OneTo{Int64}}, Int64}, true}, 1, ColumnSlices{Matrix{Float64}, Tuple{Base.OneTo{Int64}}, SubArray{Float64, 1, Matrix{Float64}, Tuple{Base.Slice{Base.OneTo{Int64}}, Int64}, true}}, Tuple{UnitRange{Int64}}, false}, ColumnSlices{Matrix{Float64}, Tuple{Base.OneTo{Int64}}, SubArray{Float64, 1, Matrix{Float64}, Tuple{Base.Slice{Base.OneTo{Int64}}, Int64}, true}}}
    @test length(y) == 6

    @test mean.(y) isa OffsetVector{Vector{Float64}, Vector{Vector{Float64}}}

    z = rolling(rand(10), 1, 3)
    @test z isa MovingWindowArrays.MovingWindowVector{SubArray{Float64, 1, Vector{Float64}, Tuple{UnitRange{Int64}}, true}, Vector{Float64}}
end
