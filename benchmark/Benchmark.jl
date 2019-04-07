workspace()

using BenchmarkTools
using EAGOSmoothMcCormickGrad
using EAGOIntervalArithmetic
using StaticArrays
cc1 = 7.0
cv1 = 2.0
cc_sub1 = ones(SVector{3,Float64})
cv_sub1 = ones(SVector{3,Float64})
intv1 = MCInterval{Float64}(3.0, 6.0)
flag1 = false
boxy1 = SVector{3,MCInterval{Float64}}([MCInterval{Float64}(3.0, 6.0),MCInterval{Float64}(3.0, 6.0),MCInterval{Float64}(3.0, 6.0)])
refy1 = SVector{3,Float64}([4.0,4.0,4.0])

cc2 = 9.0
cv2 = 1.0
cc_sub2 = ones(SVector{3,Float64})
cv_sub2 = ones(SVector{3,Float64})
intv2 = MCInterval{Float64}(2.0, 8.0)
flag2 = false
boxy2 = SVector{3,MCInterval{Float64}}([MCInterval{Float64}(3.0, 6.0),MCInterval{Float64}(3.0, 6.0),MCInterval{Float64}(3.0, 6.0)])
refy2 = SVector{3,Float64}([4.0,4.0,4.0])

a1 = SMCg{3,MCInterval{Float64},Float64}(cc1,cv1,cc_sub1,cv_sub1,intv1,flag1,boxy1,refy1)
a2 = SMCg{3,MCInterval{Float64},Float64}(cc2,cv2,cc_sub2,cv_sub2,intv2,flag2,boxy2,refy2)
@benchmark SMCg{3,MCInterval{Float64},Float64}($cc1,$cv1,$cc_sub1,$cv_sub1,$intv1,$flag1,$boxy1,$refy1)
@benchmark sin($a)

@benchmark cos($a)

@benchmark sin($a)

@benchmark cos($a)
@benchmark sin($a)
@benchmark tan($a)

b = MCInterval(-2.0,3.0)
c = MCInterval(-1.0,4.0)
#=
println("Benchmark Uncorrected Multiplication")
@benchmark $b*$c

println("Benchmark Uncorrected Addition (3.5x speed up)")
@benchmark $b+$c

println("Benchmark Uncorrected Subtraction")
@benchmark $b-$c
=#
println("Benchmark Uncorrected Tangent")
@benchmark sin($b)

println("Benchmark Uncorrected Cosine")
@benchmark sin($b)

println("Benchmark Uncorrected Sine")
@benchmark sin($b)

println("Benchmark Uncorrected Sine")
@benchmark sin($b)

#=
println("Benchmark Uncorrected Multiplication (Float64)")
@benchmark $b*1.1

println("Benchmark Uncorrected Subtraction (Float64)")
@benchmark $b-$1.1

println("Benchmark Uncorrected Addition (Float64)")
@benchmark $b+1.1
=#
function f1(x::Float64)
    t::Float64 = exp(x)
    t,t
end
