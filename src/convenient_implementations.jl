# some implementations for convenience
# maintained by Zach Sunberg

function POMDPs.support(c::Union{AbstractVector,Tuple,AbstractRange,Base.Generator})
    Base.depwarn("Use of $(typeof(c)) as a distribution is deprecated. Use POMDPTools.Uniform instead.", :support)
    return c
end
