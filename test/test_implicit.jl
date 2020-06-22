struct IMDP <: MDP{Float64, Int} end

function POMDPs.transition(m::IMDP, s, a)
    ImplicitDistribution(s, a) do s, a, rng
        return s + a + rand(rng)
    end
end

m = IMDP()

td = transition(m, 1.0, 1)
@test 2 <= rand(td) <= 3
