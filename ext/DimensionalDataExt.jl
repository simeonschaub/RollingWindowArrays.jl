module DimensionalDataExt

using RollingWindowArrays
using RollingWindowArrays: RollingWindowVector
using DimensionalData
using Base: IdentityUnitRange
using ConstructionBase: constructorof

function RollingWindowArrays._selectdim(a::AbstractDimArray, ::Val{dims}, idx::UnitRange{Int}) where {dims <: DimensionalData.Dimension}
    return view(a, DimensionalData.dims2indices(a, dims(idx))...)
end

function RollingWindowArrays.rolling(x::AbstractDimVector, before::Int, after::Int; dims = 1)
    ax = dims isa Int ? DimensionalData.dims(x)[dims] : DimensionalData.dims(x, dims)
    return DimArray(
        RollingWindowVector(x, before, after; dims),
        (ax[IdentityUnitRange((begin + before):(end - after))],);
        name = name(x), refdims = refdims(x), metadata = metadata(x),
    )
end

function RollingWindowArrays.rolling(x::AbstractDimArray, before::Int, after::Int; dims)
    ax = dims isa Int ? DimensionalData.dims(x)[dims] : DimensionalData.dims(x, dims)
    others = dims isa Int ? (DimensionalData.dims(x)[1:dims - 1]..., DimensionalData.dims(x)[dims + 1:end]...) : otherdims(x, dims)
    return DimArray(
        RollingWindowVector(x, before, after; dims),
        (ax[IdentityUnitRange((begin + before):(end - after))],);
        name = name(x), refdims = (others..., refdims(x)...), metadata = metadata(x),
    )
end

end
