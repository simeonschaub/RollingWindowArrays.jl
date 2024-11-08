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
    return (axes(parent, 1)[begin + before:end - after],)
end
Base.@propagate_inbounds function Base.getindex((; parent, before, after)::RollingWindowVector, i::Int)
    return view(parent, i - before:i + after)
end

function rolling(x::AbstractVector, before::Int, after::Int; dims = nothing)
    return RollingWindowVector(x, before, after)
end

function rolling(x::AbstractArray, before::Int, after::Int; dims)
    return RollingWindowVector(eachslice(x; dims), before, after)
end

end
