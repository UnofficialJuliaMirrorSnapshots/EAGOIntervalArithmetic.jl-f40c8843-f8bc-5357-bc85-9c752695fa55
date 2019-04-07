using EAGOIntervalArithmetic

a = MCInterval(2.0,3.0)
b = MCInterval(-3.0,-1.0)
c = MCInterval(-2.0,4.0)

t1 = pow(a,2)
t2 = pow(b,2)
t3 = pow(c,2)
t4 = pow(a,3)
t5 = pow(b,3)
t6 = pow(c,3)
t7 = pow(a,1)
t8 = pow(b,1)
t9 = pow(c,1)
t10 = pow(a,0)
t11 = pow(b,0)
t12 = pow(c,0)

t1a = ^(a,2)
t2a = ^(b,2)
t3a = ^(c,2)
t4a = ^(a,3)
t5a = ^(b,3)
t6a = ^(c,3)
t7a = ^(a,1)
t8a = ^(b,1)
t9a = ^(c,1)
t10a = ^(a,0)
t11a = ^(b,0)
t12a = ^(c,0)
t13a = ^(a,-2)
t14a = ^(b,-2)
t15a = ^(c,-2)
t16a = ^(a,-3)
t17a = ^(b,-3)
t18a = ^(c,-3)
t19a = ^(a,-1)
t20a = ^(b,-1)
t21a = ^(c,-1)

t1b = 1.0/t1
t4b = 1.0/t4
t7b = 1.0/t7
