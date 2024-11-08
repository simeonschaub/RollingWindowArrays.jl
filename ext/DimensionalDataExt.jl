module DimensionalDataExt

using MovingWindowArrays
using MovingWindowArrays: MovingWindowVector
using DimensionalData
using Base: IdentityUnitRange

function MovingWindowArrays.rolling(x::AbstractDimVector, before::Int, after::Int; dims = nothing)
    return DimArray(
        MovingWindowVector(x, before, after),
        (only(DimensionalData.dims(x))[IdentityUnitRange(begin + before:end - after)],);
        name = name(x), refdims = refdims(x), metadata = metadata(x),
    )
end

function MovingWindowArrays.rolling(x::AbstractDimArray, before::Int, after::Int; dims)
    return DimArray(
        MovingWindowVector(eachslice(x; dims), before, after),
        (DimensionalData.dims(x, dims)[IdentityUnitRange(begin + before:end - after)],),
        name = name(x), refdims = refdims(x), metadata = metadata(x),
    )
end

end
