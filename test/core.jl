@testitem "core functionality" begin
    using Statistics, OffsetArrays

    x = rand(10, 10)
    y = rolling(x, 2, 2; dims = 2)
    @test y isa RollingWindowArrays.RollingWindowVector{SubArray{Float64, 2, Matrix{Float64}, Tuple{Base.Slice{Base.OneTo{Int64}}, UnitRange{Int64}}, true}, 2, Matrix{Float64}, Int64}
    @test length(y) == 6
    @test y == rolling(x, 5; center = true, dims = 2)

    @test mean.(y; dims = 2) isa OffsetVector{Matrix{Float64}, Vector{Matrix{Float64}}}
    @test mean.(rolling(x, 5; dims = 2); dims = 2) isa Vector{Matrix{Float64}}

    z = rolling(rand(10), 1, 3)
    @test z isa RollingWindowArrays.RollingWindowVector{SubArray{Float64, 1, Vector{Float64}, Tuple{UnitRange{Int64}}, true}, 1, Vector{Float64}, Int64}
    @test axes(z) == (2:7,)

    v = rand(10)
    @test rolling(v, 0, 3) == rolling(v, 4)

    @test_throws ArgumentError rolling(x, 5)

    @test identity.(rolling(rand(10), 3)) isa Vector{SubArray{Float64, 1, Vector{Float64}, Tuple{UnitRange{Int64}}, true}}
    @test axes(identity.(rolling(OffsetArray(rand(10), 0:9), 3))) == (OffsetArrays.IdOffsetRange(values = 0:7, indices = 0:7),)
end
