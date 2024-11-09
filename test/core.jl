@testitem "core functionality" begin
    using Statistics, OffsetArrays

    x = rand(10, 10)
    y = rolling(x, 2, 2; dims = 2)
    @test y isa RollingWindowArrays.RollingWindowVector{SubArray{Float64, 2, Matrix{Float64}, Tuple{Base.Slice{Base.OneTo{Int64}}, UnitRange{Int64}}, true}, Matrix{Float64}, 2}
    @test length(y) == 6
    @test y == rolling(x, 5; center = true, dims = 2)

    @test mean.(y; dims = 2) isa OffsetVector{Matrix{Float64}, Vector{Matrix{Float64}}}

    z = rolling(rand(10), 1, 3)
    @test z isa RollingWindowArrays.RollingWindowVector{SubArray{Float64, 1, Vector{Float64}, Tuple{UnitRange{Int64}}, true}, Vector{Float64}}

    v = rand(10)
    @test rolling(v, 0, 3) == rolling(v, 4)

    @test_throws ArgumentError rolling(x, 5)
end
