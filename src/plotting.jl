module Plotting

using Plots
using Plots.PlotMeasures
using LaTeXStrings
using StochLV: TimeSeries, Params

function phase_space(sys::TimeSeries,params::Params,x0,y0,tmax,Δt,N,gif=false)
    # Unpacking
    (;x,y) = sys
    (;a,b,c,f,ϵ_x,ϵ_y) = params
    # Setup
    t = LinRange(0, tmax, floor(Int64, tmax/Δt))
    init = L"$(x_0,y_0) = (%$x0,%$y0)$"
    title = L"$a=%$a, \ b=%$b, \ c=%$c, \ d=%$f$ | $\epsilon_x=%$ϵ_x, \ \epsilon_y=%$ϵ_y$ | $%$N$ realizações"
    # Fixed point
    x_ast = c/f
    y_ast = a/b
    # Static plot
    if gif == false
        p = plot(title=title, xlabel=L"$\langle X \rangle$", ylabel=L"$\langle Y \rangle$", 
            colorbar_title="Tempo", xlim=(min(x...),max(x...)), ylim=(min(y...),max(y...)), 
            left_margin=5mm, bottom_margin=5mm, top_margin=5mm,
            tickfontsize=11, guidefontsize=15, size=(1000,800))
        plot!(x, y, linez=t, color=:thermal, label=init, legendfont=font(12))
        scatter!([x_ast], [y_ast], color=:red, label=L"$(x^{\ast},y^{\ast})$", legendfont=font(12))
        return p
    else
    # Animation

    i=2
    anim = @animate while i<=length(t)
        p = plot(title=title, xlabel=L"$\langle X \rangle$", ylabel=L"$\langle Y \rangle$", 
            xlim=(min(x...),max(x...)), ylim=(min(y...),max(y...)), legend=false, 
            left_margin=4mm, bottom_margin=4mm, top_margin=5mm,
            tickfontsize=11, guidefontsize=15, size=(1000,800))
        scatter!([x_ast], [y_ast], color=:red, label=L"$(x^{\ast},y^{\ast})$", legendfont=font(12))
        plot!(x[1:i], y[1:i], linez=t, color=:thermal)
        i+=500
    end
    return anim
    end
end

function timeseries_plot(sys::TimeSeries,params::Params,x0,y0,tmax,Δt,N)
    # Unpacking
    (;x,y) = sys
    (;a,b,c,f,ϵ_x,ϵ_y) = params
    # Setup
    t = LinRange(0, tmax, floor(Int64, tmax/Δt))
    title = L"$a=%$a, \ b=%$b, \ c=%$c, \ d=%$f$ | $\epsilon_x=%$ϵ_x, \ \epsilon_y=%$ϵ_y$ | $%$N$ realizações"
    # Plot
    p = plot(title=title, xlabel="Tempo", ylabel="Médias")
    plot!(t, x, label=L"$\langle X \rangle$")
    plot!(t, y, label=L"$\langle Y \rangle$")
    return p
end

function statistics_plot(mean::TimeSeries,var::TimeSeries,params::Params,x0,y0,tmax,Δt,N)
    # Unpacking
    (;a,b,c,f,ϵ_x,ϵ_y) = params
    # Setup
    t = LinRange(0, tmax, floor(Int64, tmax/Δt))
    title = L"$a=%$a, \ b=%$b, \ c=%$c, \ d=%$f$ | $\epsilon_x=%$ϵ_x, \ \epsilon_y=%$ϵ_y$ | $%$N$ realizações"
    # Fixed point
    x_ast = c/f
    y_ast = a/b
    # Plot
    ## Mean
    px = plot(t, mean.x, ylabel=L"$\langle X \rangle$", xlabel=L"$t$", label="", color=:red)
    hline!([x_ast], color=:black, ls=:dash, label=L"$x^{\ast}$", legendfont=font(12))
    py = plot(t, mean.y, ylabel=L"$\langle Y \rangle$", xlabel=L"$t$", label="")
    hline!([y_ast], color=:black, ls=:dash, label=L"$y^{\ast}$", legendfont=font(12))
    ## Variance
    px_var = plot(t, var.x, ylabel=L"var$(X)$", xlabel=L"$t$", legend=false, color=:red)
    py_var = plot(t, var.y, ylabel=L"var$(Y)$", xlabel=L"$t$", legend=false)
    p = plot(px, py, px_var, py_var, layout=(2,2), 
        left_margin=4mm, bottom_margin=4mm, right_margin=2mm, top_margin=5mm, 
        tickfontsize=11, guidefontsize=15, size=(1200,800), plot_title=title)
    return p
end

end