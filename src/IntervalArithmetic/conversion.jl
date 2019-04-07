
# additive conversion from float to Interval
+(a::MCInterval{T}, b::T) where {T<:AbstractFloat} = MCInterval(a.lo+b,a.hi+b)
+(b::T, a::MCInterval{T}) where {T<:AbstractFloat} = MCInterval(a.lo+b,a.hi+b)
+(a::MCInterval{T}, b::S) where {S<:AbstractFloat,T<:AbstractFloat} = MCInterval(a.lo+convert(T,b),a.hi+convert(T,b))
+(b::S, a::MCInterval{T}) where {S<:AbstractFloat,T<:AbstractFloat} = MCInterval(a.lo+convert(T,b),a.hi+convert(T,b))
+(a::MCInterval{T}, b::S) where {S,T<:AbstractFloat} = MCInterval(a.lo+convert(T,b),a.hi+convert(T,b))
+(b::S, a::MCInterval{T}) where {S,T<:AbstractFloat} = MCInterval(a.lo+convert(T,b),a.hi+convert(T,b))

# substractive conversion from float to Interval
-(a::MCInterval{T}, b::T) where {T<:AbstractFloat} = MCInterval(a.lo-b,a.hi-b)
-(b::T, a::MCInterval{T}) where {T<:AbstractFloat} = MCInterval(b-a.hi,b-a.lo)
-(a::MCInterval{T}, b::S) where {S<:AbstractFloat,T<:AbstractFloat} = -(a,convert(T,b))
-(b::S, a::MCInterval{T}) where {S<:AbstractFloat,T<:AbstractFloat} = -(convert(T,b),a)
-(a::MCInterval{T}, b::S) where {S,T<:AbstractFloat} = -(a,convert(T,b))
-(b::S, a::MCInterval{T}) where {S,T<:AbstractFloat} = -(convert(T,b),a)

# multiplication conversion from float to Interval
function *(b::T, a::MCInterval{T}) where {T<:AbstractFloat}
    (isempty(a)) && return emptyMCinterval(T)
    (iszero(a) || iszero(b)) && return MCInterval{T}(zero(T),zero(T))
    if b >= zero(T)
        a.lo >= zero(T) && return MCInterval{T}(a.lo*b, a.hi*b)
        a.hi <= zero(T) && return MCInterval{T}(a.lo*b, a.hi*b)
        return MCInterval{T}(a.lo*b, a.hi*b)   # zero(T) ∈ a
    elseif b <= zero(T)
        a.lo >= zero(T) && return MCInterval{T}(a.hi*b, a.lo*b)
        a.hi <= zero(T) && return MCInterval{T}(a.hi*b, a.lo*b)
        return MCInterval{T}(a.hi*b, a.lo*b)   # zero(T) ∈ a
    else
        a.lo > zero(T) && return MCInterval{T}(a.hi*b, a.hi*b)
        a.hi < zero(T) && return MCInterval{T}(a.lo*b, a.lo*b)
        return MCInterval{T}(min(a.lo*b, a.hi*b), max(a.lo*b, a.hi*b))
    end
end
*(a::MCInterval{T}, b::T) where {T<:AbstractFloat} = b*a
*(a::MCInterval{T}, b::S) where {S<:AbstractFloat,T<:AbstractFloat} = *(a,convert(T,b))
*(b::S, a::MCInterval{T}) where {S<:AbstractFloat,T<:AbstractFloat} = *(convert(T,b),a)
*(a::MCInterval{T}, b::S) where {S,T<:AbstractFloat} = *(a,convert(T,b))
*(b::S, a::MCInterval{T}) where {S,T<:AbstractFloat} = *(convert(T,b),a)

# division conversion from float to Interval
function /(a::T, b::MCInterval{T}) where {T<:AbstractFloat}

    (isempty(b)) && return emptyMCinterval(T)
    iszero(b) && return emptyMCinterval(T)

    if b.lo > zero(T) # b strictly positive
        a >= zero(T) && return MCInterval{T}(a/b.hi, a/b.lo)
        a <= zero(T) && return MCInterval{T}(a/b.lo, a/b.hi)
        return MCInterval{T}(a.lo/b.lo, a.hi/b.lo)  # zero(T) ∈ a
    elseif b.hi < zero(T) # b strictly negative
        a >= zero(T) && return MCInterval{T}(a/b.hi, a/b.lo)
        a <= zero(T) && return MCInterval{T}(a/b.lo, a/b.hi)
        return MCInterval{T}(a/b.hi, a/b.hi)  # zero(T) ∈ a
    else   # b contains zero, but is not zero(b)
        iszero(a) && return MCInterval{T}(zero(T),zero(T))
        if iszero(b.lo)
            a >= zero(T) && return MCInterval{T}(a/b.hi, infty(T))
            a <= zero(T) && return MCInterval{T}(ninfty(T), a/b.hi)
            return entireMCinterval(T)
        elseif iszero(b.hi)
            a >= zero(T) && return MCInterval{T}(ninfty(T), a/b.lo)
            a <= zero(T) && return MCInterval{T}(a/b.lo, infty(T))
            return entireMCinterval(T)
        else
            return entireMCinterval(T)
        end
    end
end
/(a::MCInterval{T},b::T) where {T<:AbstractFloat} = inv(b)*a
/(a::MCInterval{T}, b::S) where {S<:AbstractFloat,T<:AbstractFloat} = /(a,convert(T,b))
/(b::S, a::MCInterval{T}) where {S<:AbstractFloat,T<:AbstractFloat} = /(convert(T,b),a)
/(a::MCInterval{T}, b::S) where {S,T<:AbstractFloat} = /(a,convert(T,b))
/(b::S, a::MCInterval{T}) where {S,T<:AbstractFloat} = /(convert(T,b),a)

# minimization conversion from float to Interval
function min(a::MCInterval{T}, b::T) where {T<:AbstractFloat}
    (isempty(a)) && return emptyMCinterval(T)
    MCInterval{T}( min(a.lo, b), min(a.hi, b))
end
function min(b::T, a::MCInterval{T}) where {T<:AbstractFloat}
    (isempty(a)) && return emptyinterval(T)
    MCInterval{T}( min(a.lo, b), min(a.hi, b))
end
min(a::MCInterval{T}, b::S) where {S<:AbstractFloat,T<:AbstractFloat} = min(a,convert(T,b))
min(b::S, a::MCInterval{T}) where {S<:AbstractFloat,T<:AbstractFloat} = min(convert(T,b),a)
min(a::MCInterval{T}, b::S) where {S,T<:AbstractFloat} = min(a,convert(T,b))
min(b::S, a::MCInterval{T}) where {S,T<:AbstractFloat} = min(convert(T,b),a)

# maximization conversion from float to Interval
function max(a::MCInterval{T}, b::T) where {T<:AbstractFloat}
    (isempty(a)) && return emptyMCinterval(T)
    MCInterval{T}( max(a.lo, b), max(a.hi, b))
end
function max(b::T, a::MCInterval{T}) where {T<:AbstractFloat}
    (isempty(a)) && return emptyMCinterval(T)
    MCInterval{T}( max(a.lo, b), max(a.hi, b))
end
max(a::MCInterval{T}, b::S) where {S<:AbstractFloat,T<:AbstractFloat} = max(a,convert(T,b))
max(b::S, a::MCInterval{T}) where {S<:AbstractFloat,T<:AbstractFloat} = max(convert(T,b),a)
max(a::MCInterval{T}, b::S) where {S,T<:AbstractFloat} = max(a,convert(T,b))
max(b::S, a::MCInterval{T}) where {S,T<:AbstractFloat} = max(convert(T,b),a)

# nonoverloaded conversion
flttoMCI(x::Float64) = MCInterval{Float64}(x,x)
flttoMCI(x::Float32) = MCInterval{Float32}(x,x)
flttoMCI(x::Float16) = MCInterval{Float16}(x,x)
