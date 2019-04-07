# EAGOIntervalArithmetic.jl #

[![Build Status](https://travis-ci.org/MatthewStuber/EAGOIntervalArithmetic.jl.svg?branch=master)](https://travis-ci.org/MatthewStuber/EAGOIntervalArithmetic.jl)

[![Coverage Status](https://coveralls.io/repos/MatthewStuber/EAGOIntervalArithmetic.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/MatthewStuber/EAGOIntervalArithmetic.jl?branch=master)

[![codecov.io](http://codecov.io/github/MatthewStuber/EAGOIntervalArithmetic.jl/coverage.svg?branch=master)](http://codecov.io/github/MatthewStuber/EAGOIntervalArithmetic.jl?branch=master)

`EAGOIntervalArithmetic.jl` is essentially a copy of the `IntervalArithmetic.jl` and `IntervalContractors.jl`
package in which all routines used for validated rounding are removed. It's meant to provide
a much higher speed back-end for `EAGOSmoothMcCormickGrad.jl` and `EAGOParametricInterval.jl`
routines used in the `EAGO` global solver. For many McCormick operators, the use of the **nonvalidated operators will increase computation speed by between 3x-200x**. Additionally, the nonvalidated library avoids any memory allocation.

The EAGOIntervalArithmetic.jl library introduces the type `MCInterval{T<:AbstractFloat}(lo::T,hi::T)`. Neglecting the rounding behavior it behaves identically to the `Interval(lo,hi)` type.


![BenchmarkChart](https://github.com/MatthewStuber/EAGOIntervalArithmetic/blob/master/docs/BenchmarkChart.jpg)

Since the McCormick relaxations used in this solver aren't themselves correctly rounded, it's often acceptable to omit corrections for rounding in the interval field. For problems there are very poorly scaled or have very poorly scaled intermediate terms, the use of a corrected rounding procedures may be recommended.

# Related Packages
[ValidatedNumerics.jl](https://github.com/JuliaIntervals/ValidatedNumerics.jl), a collection of the interval libraries for validated interval calculations that this package is based on.
