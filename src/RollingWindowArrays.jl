module RollingWindowArrays

using OffsetArrays

export rolling

function _selectdim(a::AbstractArray, ::Val{dims}, idx::UnitRange{Int}) where {dims}
    return selectdim(a, dims, idx)
end

# range that semantically always starts at `begin` of the indexed array
struct BeginTo <: AbstractUnitRange{Int}
    start::Int
    stop::Int
end

@inline Base.getindex(a::Base.OneTo, b::BeginTo) = (@boundscheck checkbounds(a, b); Base.OneTo(last(b)))
@inline Base.getindex(a::Base.OneTo, b::Base.IdentityUnitRange{BeginTo}) = (@boundscheck checkbounds(a, b); Base.OneTo(last(b)))

struct RollingWindowVector{T, dims, A <: AbstractArray, B <: Union{Int, Nothing}} <: AbstractVector{T}
    parent::A
    before::B
    after::Int
end

function RollingWindowVector(parent::A, before::B, after::Int; dims::Int) where {A <: AbstractArray, B <: Union{Int, Nothing}}
    T = Core.Compiler.return_type(_selectdim, Tuple{A, Val{dims}, UnitRange{Int}})
    return RollingWindowVector{T, dims, A, B}(parent, before, after)
end
function Base.size((; parent, before, after)::RollingWindowVector{<:Any, dims}) where {dims}
    before = before === nothing ? 0 : before
    return (size(parent, dims) - before - after,)
end
function Base.axes((; parent, before, after)::RollingWindowVector{<:Any, dims}) where {dims}
    return (axes(parent, dims)[before === nothing ? BeginTo(begin, end - after) : (begin + before):(end - after)],)
end
Base.@propagate_inbounds function Base.getindex((; parent, before, after)::RollingWindowVector{<:Any, dims}, i::Int) where {dims}
    before = before === nothing ? 0 : before
    return _selectdim(parent, Val(dims), (i - before):(i + after))
end

function rolling(x::AbstractVector, before::Union{Int, Nothing}, after::Int; dims = 1)
    return RollingWindowVector(x, before, after; dims)
end
function rolling(x::AbstractArray, before::Union{Int, Nothing}, after::Int; dims)
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
    if center
        offset = window_size ÷ 2
        return rolling(x, offset, window_size - offset - 1; dims)
    else
        return rolling(x, nothing, window_size - 1; dims)
    end
end

end
