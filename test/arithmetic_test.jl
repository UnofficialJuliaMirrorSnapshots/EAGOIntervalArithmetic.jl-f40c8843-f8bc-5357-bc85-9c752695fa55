using EAGOIntervalArithmetic

a = MCInterval(2.0,3.0)
b = MCInterval(4.0,6.0)

@test a != b
@test a <= b
@test a < b
@test ~(a >= b)
@test ~(a > b)
#=
t1 = zero(a)
t2 = one(a)
t3 = zero(MCInterval{Float64})
t4 = one(MCInterval{Float64})
t5 = +a
t6 = -a
t7 = b-a
t8 = a+b
t9 = a*b
t10 = inv(a)
t11 = a/b
t12 = fma(a,a,b)
t13 = EAGOIntervalArithmetic.mag(a)
t14 = EAGOIntervalArithmetic.mig(a)
t15 = EAGOIntervalArithmetic.inf(a)
t16 = EAGOIntervalArithmetic.sup(a)
t17 = real(a)
t18 = abs(a)
t20 = min(a,b)
t21 = max(a,b)
t22 = EAGOIntervalArithmetic.dist(a,b)
t23 = eps(a)
t24 = floor(a)
t25 = ceil(a)
t26 = trunc(a)
t27 = sign(a)
t28 = EAGOIntervalArithmetic.mid(a,0.4)
t29 = EAGOIntervalArithmetic.mid(a)
t30 = EAGOIntervalArithmetic.diam(a)
t31 = EAGOIntervalArithmetic.radius(a)
=#
