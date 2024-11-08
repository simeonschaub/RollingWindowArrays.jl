module DimensionalDataExt

using RollingWindowArrays
using RollingWindowArrays: RollingWindowVector
using DimensionalData
using Base: IdentityUnitRange

function RollingWindowArrays.rolling(x::AbstractDimVector, before::Int, after::Int; dims = nothing)
    return DimArray(
        RollingWindowVector(x, before, after),
        (only(DimensionalData.dims(x))[IdentityUnitRange((begin + before):(end - after))],);
        name = name(x), refdims = refdims(x), metadata = metadata(x),
    )
end

function RollingWindowArrays.rolling(x::AbstractDimArray, before::Int, after::Int; dims)
    return DimArray(
        RollingWindowVector(eachslice(x; dims), before, after),
        (DimensionalData.dims(x, dims)[IdentityUnitRange((begin + before):(end - after))],),
        name = name(x), refdims = refdims(x), metadata = metadata(x),
    )
end

end
