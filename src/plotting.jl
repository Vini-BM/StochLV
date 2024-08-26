module Plotting

using Plots
using LaTeXStrings
using StochLV: TimeSeries, Params

function phase_space(sys::TimeSeries,params::Params,x0,y0,tmax,Δt,N,gif=false)
    # Setup
    (;x,y) = sys
    t = LinRange(0, tmax, floor(Int64, tmax/Δt))
    init = L"$(x_0,y_0) = (%$x0,%$y0)$"
    title = L"Espaço de fase | %$N realizações | $\epsilon_x = %$(params.ϵ_x), \ \epsilon_y = %$(params.ϵ_y)$"
    # Static plot
    if gif == false
        p = plot(title=title, xlabel=L"$\langle X \rangle$", ylabel=L"$\langle Y \rangle$", 
            colorbar_title="Tempo", xlim=(min(x...),max(x...)), ylim=(min(y...),max(y...)))
        plot!(x, y, linez=t, color=:viridis, label=init)
        return p
    else
    # Animation
    i=2
    anim = @animate while i<=length(t)
        p = plot(title=title, xlabel=L"$\langle X \rangle$", ylabel=L"$\langle Y \rangle$", 
            xlim=(min(x...),max(x...)), ylim=(min(y...),max(y...)), legend=false)
        plot!(x[1:i], y[1:i], linez=t, color=:viridis)
        i+=500
    end
    return anim
    end
end

function stats_plot(sys::TimeSeries,params::Params,x0,y0,tmax,Δt,N)
    (;x,y) = sys
    t = LinRange(0, tmax, floor(Int64, tmax/Δt))
    p = plot(title=L"Série temporal | %$N realizações | $\epsilon_x = %$(params.ϵ_x), \ \epsilon_y = %$(params.ϵ_y)$", 
        xlabel="Tempo", ylabel="Médias")
    plot!(t, x, label=L"$\langle X \rangle$")
    plot!(t, y, label=L"$\langle Y \rangle$")
    return p
end

end