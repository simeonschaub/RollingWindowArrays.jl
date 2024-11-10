module DimensionalDataExt

using RollingWindowArrays
using RollingWindowArrays: RollingWindowVector, BeginTo
using DimensionalData
using Base: IdentityUnitRange

function RollingWindowArrays.rolling(x::AbstractDimVector, before::Union{Int, Nothing}, after::Int; dims = 1)
    dims = dimnum(x, dims)
    return DimArray(
        RollingWindowVector(x, before, after; dims),
        (DimensionalData.dims(x, dims)[IdentityUnitRange(before === nothing ? BeginTo(begin, end - after) : (begin + before):(end - after))],);
        name = name(x), refdims = refdims(x), metadata = metadata(x),
    )
end

function RollingWindowArrays.rolling(x::AbstractDimArray, before::Union{Int, Nothing}, after::Int; dims)
    dims = dimnum(x, dims)
    return DimArray(
        RollingWindowVector(x, before, after; dims),
        (DimensionalData.dims(x, dims)[IdentityUnitRange(before === nothing ? BeginTo(begin, end - after) : (begin + before):(end - after))],);
        name = name(x), refdims = (otherdims(x, dims)..., refdims(x)...), metadata = metadata(x),
    )
end

end
