let
    pomdp = BabyPOMDP()
    up = updater(pomdp)

    bmdp = GenerativeBeliefMDP(pomdp, up)
    b = initialstate(bmdp, Random.GLOBAL_RNG)
    if VERSION >= v"1.1"
        @inferred generate_sr(bmdp, b, true, MersenneTwister(4))
    end
end
