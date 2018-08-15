let
    mdp = GridWorld()

    pomdp = FullyObservablePOMDP(mdp)

    @test observations(pomdp) == states(pomdp)
    @test n_observations(pomdp) == n_states(pomdp)
    @test state_type(pomdp) == obs_type(pomdp)

    s_po = initialstate(pomdp, MersenneTwister(1))
    s_mdp = initialstate(mdp, MersenneTwister(1))
    @test s_po == s_mdp

    solver = ValueIterationSolver(max_iterations = 100)
    mdp_policy = solve(solver, mdp, verbose=false)
    pomdp_policy = solve(solver, pomdp, verbose=false)
    @test mdp_policy.util == pomdp_policy.util
end
