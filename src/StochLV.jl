module StochLV

export TimeSeries, Params

@kwdef struct TimeSeries{T}
    x::Array{T} # prey
    y::Array{T} # predator
end

@kwdef struct Params
    a::Float64 # prey growth
    b::Float64 # prey death by predator
    c::Float64 # predator death
    f::Float64 # predator growth by prey
    ϵ_x::Float64 # noise intensity for prey
    ϵ_y::Float64 # noise intensity for predator
end

include("plotting.jl")
include("integration.jl")

end