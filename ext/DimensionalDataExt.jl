module DimensionalDataExt

using RollingWindowArrays
using RollingWindowArrays: RollingWindowVector, BeginTo
using DimensionalData
using DimensionalData.Dimensions: DimUnitRange, Dimension
using DimensionalData.Dimensions.Lookups: Sampled
using Base: OneTo, IdentityUnitRange

Base.getindex(a::DimUnitRange{<:Any, <:Base.OneTo}, b::BeginTo) = a[OneTo(last(b))]
Base.getindex(a::Dimension{<:Sampled{<:Any, <:UnitRange}}, b::IdentityUnitRange{BeginTo}) = a[IdentityUnitRange(OneTo(last(b)))]

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
