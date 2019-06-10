d = SparseCat([1,2], [0.5, 0.5])
@test sprint(showdistribution, d) == "     SparseCat{Array{Int64,1},Array{Float64,1}} distribution\n     ┌                                        ┐ \n   1 ┤■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 0.5   \n   2 ┤■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 0.5   \n     └                                        ┘ "

d = SparseCat(1:50, fill(1/50, 50))
iob = IOBuffer()
io = IOContext(iob, :limit=>true, :displaysize=>(10, 7))
showdistribution(io, d)
@test String(take!(iob)) == "                     SparseCat{UnitRange{Int64},Array{Float64,1}} distribution\n                     ┌                                        ┐ \n                   1 ┤■ 0.02                                    \n                   2 ┤■ 0.02                                    \n                   3 ┤■ 0.02                                    \n   <everything else> ┤■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 0.94   \n                     └                                        ┘ "
