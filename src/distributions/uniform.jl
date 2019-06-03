"""
    Uniform(collection)

Create a categorical distribution over a collection of objects.
"""
mutable struct Uniform{C, T}
    collection::C
    _set::Union{Set{T}, Nothing} # keep track of what's in the collection to make pdf more efficient
end

Uniform(c) = Uniform{typeof(c), eltype(c)}(c, nothing)
Uniform(c::Set) = Uniform{typeof(c), eltype(c)}(c, c)

rand(rng::AbstractRNG, d::Uniform) = rand(rng, d.collection)
rand(rng::AbstractRNG, d::Uniform{<:NamedTuple}) = d.collection[rand(rng, 1:length(d.collection))]

support(d::Uniform) = d.collection
sampletype(::Type{Uniform{C, T}}) where {C,T} = T

function pdf(d::Uniform, s)
    d._set = something(d._set, Set(d.collection))
    if s in d._set
        return 1/length(d.collection)
    else
        return 0.0
    end
end

mode(d::Uniform) = mode(d.collection)
mean(d::Uniform) = mean(d.collection)

function weighted_iterator(d::Uniform)
    p = 1/length(d.collection)
    return (x=>p for x in d.collection)
end
