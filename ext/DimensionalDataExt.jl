module DimensionalDataExt

using RollingWindowArrays
using RollingWindowArrays: RollingWindowVector
using DimensionalData
using Base: IdentityUnitRange
using ConstructionBase: constructorof

function RollingWindowArrays._selectdim(a::AbstractDimArray, ::Val{dims}, idx::UnitRange{Int}) where {dims}
    return view(a, DimensionalData.dims2indices(a, dims(idx))...)
end

function RollingWindowArrays.rolling(x::AbstractDimVector, before::Int, after::Int; dims = constructorof(typeof(only(DimensionalDataExt.dims(x)))))
    return DimArray(
        RollingWindowVector(x, before, after; dims),
        (DimensionalData.dims(x, dims)[IdentityUnitRange((begin + before):(end - after))],);
        name = name(x), refdims = refdims(x), metadata = metadata(x),
    )
end

function RollingWindowArrays.rolling(x::AbstractDimArray, before::Int, after::Int; dims)
    return DimArray(
        RollingWindowVector(x, before, after; dims),
        (DimensionalData.dims(x, dims)[IdentityUnitRange((begin + before):(end - after))],);
        name = name(x), refdims = (otherdims(x, dims)..., refdims(x)...), metadata = metadata(x),
    )
end

end
