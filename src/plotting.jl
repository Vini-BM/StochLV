module Plotting

using Plots
using StochLV: TimeSeries, Params

function phase_space(sys::TimeSeries,params::Params,x0,y0,tmax,Δt,N)
    (;x,y) = sys
    t = LinRange(0, tmax, floor(Int64, tmax/Δt))
    init = "(x0,y0) = ($x0,$y0)"
    p = plot(x, y, linez=t, color=:viridis, size=(600,600))
    plot!(title="Espaço de fase ($N realizações)", zlabel="Tempo", xlabel="Número de Presas", ylabel="Número de Predadores")
    return p
end

function stats_plot(sys::TimeSeries,params::Params,x0,y0,tmax,Δt,N)
    p = plot(t, x, label="Média de presas", size=(800,600))
    plot!(t, y, label="Média de predadores")
    plot!(title="Médias sobre $N realizações", xlabel="Tempo", ylabel="Médias")
    return p
end

end