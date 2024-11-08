module RollingWindowArrays

using OffsetArrays

export rolling

struct RollingWindowVector{T, A <: AbstractVector} <: AbstractVector{T}
    parent::A
    before::Int
    after::Int
end

function RollingWindowVector(parent::A, before::Int, after::Int) where {A <: AbstractVector}
    T = Core.Compiler.return_type(view, Tuple{A, UnitRange{Int}})
    return RollingWindowVector{T, A}(parent, before, after)
end
function Base.size((; parent, before, after)::RollingWindowVector)
    return (size(parent, 1) - before - after,)
end
function Base.axes((; parent, before, after)::RollingWindowVector)
    return (axes(parent, 1)[(begin + before):(end - after)],)
end
Base.@propagate_inbounds function Base.getindex((; parent, before, after)::RollingWindowVector, i::Int)
    return view(parent, (i - before):(i + after))
end

function rolling(x::AbstractVector, before::Int, after::Int; dims = nothing)
    return RollingWindowVector(x, before, after)
end
function rolling(x::AbstractArray, before::Int, after::Int; dims)
    return RollingWindowVector(eachslice(x; dims), before, after)
end

"""
    rolling(x::AbstractArray, window_size::Int; center = false[, dims])

Create a rolling window view of array `x` with window size `window_size`. If `center` is true, the
window is centered on each element, which is relevant for the axes of the resulting array. For
multidimensional arrays, the `dims` argument is required and specifies the dimensions along which
to apply the rolling window.
"""
function rolling(x::AbstractArray, window_size::Int; center = false, dims = nothing)
    if !(x isa AbstractVector) && dims === nothing
        throw(ArgumentError("`dims` keyword is required for multidimensional arrays"))
    end
    offset = center ? window_size ÷ 2 : 0
    return rolling(x, offset, window_size - offset - 1; dims)
end

end
