module RollingWindowArrays

using OffsetArrays

export rolling

function _selectdim(a::AbstractArray, ::Val{dims}, idx::UnitRange{Int}) where {dims}
    return selectdim(a, dims, idx)
end

struct RollingWindowVector{T, A <: AbstractArray, dims} <: AbstractVector{T}
    parent::A
    before::Int
    after::Int
end

function RollingWindowVector(parent::A, before::Int, after::Int; dims::Int) where {A <: AbstractArray}
    T = Core.Compiler.return_type(_selectdim, Tuple{A, Val{dims}, UnitRange{Int}})
    return RollingWindowVector{T, A, dims}(parent, before, after)
end
function Base.size((; parent, before, after)::RollingWindowVector{<:Any, <:Any, dims}) where {dims}
    return (size(parent, dims) - before - after,)
end
function Base.axes((; parent, before, after)::RollingWindowVector{<:Any, <:Any, dims}) where {dims}
    return (axes(parent, dims)[(begin + before):(end - after)],)
end
Base.@propagate_inbounds function Base.getindex(
        (; parent, before, after)::RollingWindowVector{<:Any, <:Any, dims}, i::Int
    ) where {dims}
    return _selectdim(parent, Val(dims), (i - before):(i + after))
end

function rolling(x::AbstractVector, before::Int, after::Int; dims = 1)
    return RollingWindowVector(x, before, after; dims)
end
function rolling(x::AbstractArray, before::Int, after::Int; dims)
    return RollingWindowVector(x, before, after; dims)
end

"""
    rolling(x::AbstractArray, window_size::Int; center = false[, dims])

Create a rolling window view of array `x` with window size `window_size`. If `center` is true, the
window is centered on each element, which is relevant for the axes of the resulting array. For
multidimensional arrays, the `dims` argument is required and specifies the dimensions along which
to apply the rolling window.
"""
function rolling(x::AbstractArray, window_size::Int; center = false, dims = nothing)
    if dims === nothing
        if x isa AbstractVector
            dims = 1
        else
            throw(ArgumentError("`dims` keyword is required for multidimensional arrays"))
        end
    end
    offset = center ? window_size ÷ 2 : 0
    return rolling(x, offset, window_size - offset - 1; dims)
end

end
