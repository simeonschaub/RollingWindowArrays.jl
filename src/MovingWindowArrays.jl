module MovingWindowArrays

using OffsetArrays

export rolling

struct MovingWindowVector{T, A <: AbstractVector} <: AbstractVector{T}
    parent::A
    before::Int
    after::Int
end

function MovingWindowVector(parent::A, before::Int, after::Int) where {A <: AbstractVector}
    T = Core.Compiler.return_type(view, Tuple{A, UnitRange{Int}})
    return MovingWindowVector{T, A}(parent, before, after)
end
function Base.size((; parent, before, after)::MovingWindowVector)
    return (size(parent, 1) - before - after,)
end
function Base.axes((; parent, before, after)::MovingWindowVector)
    return (axes(parent, 1)[begin + before:end - after],)
end
Base.@propagate_inbounds function Base.getindex((; parent, before, after)::MovingWindowVector, i::Int)
    return view(parent, i - before:i + after)
end

function rolling(x::AbstractVector, before::Int, after::Int; dims = nothing)
    return MovingWindowVector(x, before, after)
end

function rolling(x::AbstractArray, before::Int, after::Int; dims)
    return MovingWindowVector(eachslice(x; dims), before, after)
end

end
