# This file is part of the IntervalArithmetic.jl package; MIT licensed

half_pi(::Type{T}) where T = pi_MCinterval(T) / 2.0
half_pi(x::T) where T<:AbstractFloat = half_pi(T)

const pih64 = pi_MCinterval(Float64)/Float64(2.0)
const pih32 = pi_MCinterval(Float32)/Float32(2.0)
const pih16 = pi_MCinterval(Float16)/Float16(2.0)

const pi264 = pi_MCinterval(Float64)*Float64(2.0)
const pi232 = pi_MCinterval(Float32)*Float32(2.0)
const pi216 = pi_MCinterval(Float16)*Float16(2.0)

two_pi(::Type{Float64}) = pi264
two_pi(::Type{Float32}) = pi232
two_pi(::Type{Float16}) = pi216

range_atan2(::Type{T}) where {T<:AbstractFloat} = MCInterval{T}(-(pi_MCinterval(T).hi), pi_MCinterval(T).hi)
half_range_atan2(::Type{T}) where {T} = (temp = half_pi(T); Interval(-(temp.hi), temp.hi) )
pos_range_atan2(::Type{T}) where {T<:AbstractFloat} = MCInterval{T}(zero(T), pi_MCinterval(T).hi)

function find_quadrants(x::Float64)
    temp = x/pih64
    (floor(temp.lo), floor(temp.hi))
end
function find_quadrants(x::Float32)
    temp = x/pih32
    (floor(temp.lo), floor(temp.hi))
end
function find_quadrants(x::Float16)
    temp = x/pih16
    (floor(temp.lo), floor(temp.hi))
end

function sin(a::MCInterval{T}) where {T<:AbstractFloat}
    isempty(a) && return a

    whole_range::MCInterval{T} = MCInterval{T}(-one(T), one(T))
    diam(a) > two_pi(T).lo && return whole_range

    lo1::Int64,lo2::Int64 = find_quadrants(a.lo)
    hi1::Int64,hi2::Int64 = find_quadrants(a.hi)
    lo_quadrant = min(lo1,lo2)
    hi_quadrant = max(hi1,hi2)

    if hi_quadrant - lo_quadrant > 4  # close to limits
        return whole_range
    end

    lo_quadrant = mod(lo_quadrant, 4)
    hi_quadrant = mod(hi_quadrant, 4)

    # Different cases depending on the two quadrants:
    if lo_quadrant == hi_quadrant
        a.hi - a.lo > pi_MCinterval(T).lo && return whole_range
        lo::MCInterval{T} = MCInterval{T}(sin(a.lo), sin(a.lo))
        hi::MCInterval{T} = MCInterval{T}(sin(a.hi), sin(a.hi))
        return hull(lo, hi)
    elseif lo_quadrant==3 && hi_quadrant==0
        return MCInterval{T}(sin(a.lo), sin(a.hi))
    elseif lo_quadrant==1 && hi_quadrant==2
        return MCInterval{T}(sin(a.hi), sin(a.lo))
    elseif ( lo_quadrant == 0 || lo_quadrant==3 ) && ( hi_quadrant==1 || hi_quadrant==2 )
        return MCInterval{T}(min(sin(a.lo), sin(a.hi)), one(T))
    elseif ( lo_quadrant == 1 || lo_quadrant==2 ) && ( hi_quadrant==3 || hi_quadrant==0 )
        return MCInterval{T}(-one(T), max(sin(a.lo), sin(a.hi)))
    else
        return whole_range
    end
end

function cos(a::MCInterval{T}) where {T<:AbstractFloat}
    isempty(a) && return a

    whole_range = MCInterval(-one(T), one(T))

    diam(a) > two_pi(T).lo && return whole_range

    lo1::Int64,lo2::Int64 = find_quadrants(a.lo)
    hi1::Int64,hi2::Int64 = find_quadrants(a.hi)
    lo_quadrant = min(lo1,lo2)
    hi_quadrant = max(hi1,hi2)

    if hi_quadrant - lo_quadrant > 4  # close to limits
        return MCInterval{T}(-one(T), one(T))
    end

    lo_quadrant = mod(lo_quadrant, 4)
    hi_quadrant = mod(hi_quadrant, 4)

    # Different cases depending on the two quadrants:
    if lo_quadrant == hi_quadrant # Interval limits in the same quadrant
        a.hi - a.lo > pi_interval(T).lo && return whole_range
        lo = MCInterval{T}(cos(a.lo), cos(a.lo))
        hi = MCInterval{T}(cos(a.hi), cos(a.hi))
        return hull(lo, hi)
    elseif lo_quadrant == 2 && hi_quadrant==3
        return MCInterval{T}(cos(a.lo), cos(a.hi))
    elseif lo_quadrant == 0 && hi_quadrant==1
        return MCInterval{T}(cos(a.hi), cos(a.lo))
    elseif ( lo_quadrant == 2 || lo_quadrant==3 ) && ( hi_quadrant==0 || hi_quadrant==1 )
        return MCInterval{T}(min(cos(a.lo), cos(a.hi)), one(T))
    elseif ( lo_quadrant == 0 || lo_quadrant==1 ) && ( hi_quadrant==2 || hi_quadrant==3 )
        return MCInterval{T}(-one(T), max(cos(a.lo), cos(a.hi)))
    else
        return whole_range
    end
end

function tan(a::MCInterval{T}) where {T<:AbstractFloat}
    isempty(a) && return a

    diam(a) > pi_MCinterval(T).lo && return entireMCinterval(T)

    lo1::Int64,lo2::Int64 = find_quadrants(a.lo)
    hi1::Int64,hi2::Int64 = find_quadrants(a.hi)
    lo_quadrant = min(lo1,lo2)
    hi_quadrant = max(hi1,hi2)

    lo_quadrant_mod = mod(lo_quadrant, 2)
    hi_quadrant_mod = mod(hi_quadrant, 2)

    if lo_quadrant_mod == 0 && hi_quadrant_mod == 1
        # check if really contains singularity:
        if hi_quadrant * half_pi(T) ⊆ a
            return entireMCinterval(T)  # crosses singularity
        end

    elseif lo_quadrant_mod == hi_quadrant_mod && hi_quadrant > lo_quadrant
        # must cross singularity
        return entireMCinterval(T)

    end

    return MCInterval{T}(tan(a.lo), tan(a.hi))
end

function asin(a::MCInterval{T}) where {T<:AbstractFloat}

    domain = MCInterval{T}(-one(T), one(T))
    a = a ∩ domain

    isempty(a) && return a

    return MCInterval{T}(asin(a.lo), asin(a.hi))
end

function acos(a::MCInterval{T}) where {T<:AbstractFloat}

    domain = MCInterval{T}(-one(T), one(T))
    a = a ∩ domain

    isempty(a) && return a

    return MCInterval{T}(acos(a.hi), acos(a.lo))
end

function atan(a::MCInterval{T}) where {T<:AbstractFloat}
    isempty(a) && return a

    return MCInterval{T}(atan(a.lo), atan(a.hi))
end

function atan2(y::MCInterval{T}, x::MCInterval{T}) where {T<:AbstractFloat}
    (isempty(y) || isempty(x)) && return emptyMCinterval(T)
    # Prevent nonsense results when y has a signed zero:
    if y.lo == zero(T)
        y = MCInterval{T}(zero(T), y.hi)
    end
    if y.hi == zero(T)
        y = MCInterval{T}(y.lo, zero(T))
    end

    # Check cases based on x
    if x == zero(x)

        y == zero(y) && return emptyMCinterval(T)
        y.lo ≥ zero(T) && return half_pi(T)
        y.hi ≤ zero(T) && return -half_pi(T)
        return half_range_atan2(T)

    elseif x.lo > zero(T)

        y == zero(y) && return y
        y.lo ≥ zero(T) &&
            return MCInterval{T}(atan2(y.lo, x.hi), atan2(y.hi, x.lo)) # refinement lo bound
        y.hi ≤ zero(T) &&
            return MCInterval{T}(atan2(y.lo, x.lo), atan2(y.hi, x.hi))
        return MCInterval{T}(atan2(y.lo, x.lo), atan2(y.hi, x.lo))

    elseif x.hi < zero(T)

        y == zero(y) && return pi_MCinterval(T)
        y.lo ≥ zero(T) &&
            return MCInterval{T}(atan2(y.hi, x.hi), atan2(y.lo, x.lo))
        y.hi < zero(T) &&
            return MCInterval{T}(atan2(y.hi, x.lo), atan2(y.lo, x.hi))
        return range_atan2(T)

    else # zero(T) ∈ x

        if x.lo == zero(T)
            y == zero(y) && return y

            y.lo ≥ zero(T) && return MCInterval{T}(atan2(y.lo, x.hi), half_range_atan2(T).hi)

            y.hi ≤ zero(T) && return MCInterval{T}(half_range_atan2(T).lo, atan2(y.hi, x.hi))
            return half_range_atan2(T)

        elseif x.hi == zero(T)
            y == zero(y) && return pi_MCinterval(T)
            y.lo ≥ zero(T) && return MCInterval{T}(half_pi(T).lo, atan2(y.lo, x.lo))
            y.hi < zero(T) && return MCInterval{T}(atan2(y.hi, x.lo), -(half_pi(T).lo))
            return range_atan2(T)
        else
            y.lo ≥ zero(T) &&
                return MCInterval{T}(atan2(y.lo, x.hi), atan2(y.lo, x.lo))
            y.hi < zero(T) &&
                return MCInterval{T}(atan2(y.hi, x.lo), atan2(y.hi, x.hi))
            return range_atan2(T)
        end

    end
end
