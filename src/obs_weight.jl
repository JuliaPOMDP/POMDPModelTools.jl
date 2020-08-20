# obs_weight is a shortcut function for getting the relative likelihood of an observation without having to construct the observation distribution. Useful for particle filtering
# maintained by @zsunberg

"""
    obs_weight(pomdp, s, a, sp, o)

Return a weight proportional to the likelihood of receiving observation o from state sp (and a and s if they are present).

This is a useful shortcut for particle filtering so that the observation distribution does not have to be represented.
"""
obs_weight(p, s, a, sp, o) = pdf(observation(p, s, a, sp), o)

function POMDPLinter.implemented(::typeof(obs_weight), argtypes::Type{<:Tuple})
    in_other_module = false
    try
        m = which(obs_weight, argtypes)
        if m.module != POMDPModelTools
            in_other_module = true
        end
    end
    if in_other_module
        return true
    else
        if implemented(observation, Tuple{only(argtypes.parameters).parameters[1:end-1]...})
            Base.return_types

    end
    return missing
end
