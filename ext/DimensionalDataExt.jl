module DimensionalDataExt

using RollingWindowArrays
using RollingWindowArrays: RollingWindowVector
using DimensionalData
using Base: IdentityUnitRange

function RollingWindowArrays.rolling(x::AbstractDimVector, before::Int, after::Int; dims = 1)
    dims = dimnum(x, dims)
    return DimArray(
        RollingWindowVector(x, before, after; dims),
        (DimensionalData.dims(x, dims)[IdentityUnitRange((begin + before):(end - after))],);
        name = name(x), refdims = refdims(x), metadata = metadata(x),
    )
end

function RollingWindowArrays.rolling(x::AbstractDimArray, before::Int, after::Int; dims)
    dims = dimnum(x, dims)
    return DimArray(
        RollingWindowVector(x, before, after; dims),
        (DimensionalData.dims(x, dims)[IdentityUnitRange((begin + before):(end - after))],);
        name = name(x), refdims = (otherdims(x, dims)..., refdims(x)...), metadata = metadata(x),
    )
end

end
