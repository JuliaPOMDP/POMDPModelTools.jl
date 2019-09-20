let
    mdp = SimpleGridWorld()

    pomdp = FullyObservablePOMDP(mdp)

    @test observations(pomdp) == states(pomdp)
    @test statetype(pomdp) == obstype(pomdp)

    @test observations(pomdp) == states(pomdp)
    @test statetype(pomdp) == obstype(pomdp)
    
    s_po = initialstate(pomdp, MersenneTwister(1))
    s_mdp = initialstate(mdp, MersenneTwister(1))
    @test s_po == s_mdp

    solver = ValueIterationSolver(max_iterations = 100)
    mdp_policy = solve(solver, mdp)
    pomdp_policy = solve(solver, UnderlyingMDP(pomdp))
    @test mdp_policy.util == pomdp_policy.util

    is = initialstate(mdp, MersenneTwister(3))
    for (sp, o, r) in stepthrough(pomdp,
                               FunctionPolicy(o->:left),
                               PreviousObservationUpdater(),
                               is, is, "sp,o,r",
                               rng=MersenneTwister(2),
                               max_steps=10)
        @test sp == o
    end
end
