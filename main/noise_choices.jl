using StochLV
using StochLV.Integration
using StochLV.Plotting
using Plots

"""
Integrates the system and plots results for different choices in noise scale.
Deterministic parameters and initial conditions are kept fixed.
"""

# Deterministic parameters
a = 1.5
b = 0.1
c = 0.25
f = 0.01

# Noise scale
ϵ_list = [[0.01,0.02],[0.1,0.2],[1,2]]

# Integration parameters
Δt = 0.01
tmax = 1000
N = 100 # number of realizations

# Initial conditions
x0 = 20
y0 = 10

# Integration
for choice in ϵ_list
    ϵ_x, ϵ_y = choice
    params = Params(a=a,b=b,c=c,f=f,ϵ_x=ϵ_x,ϵ_y=ϵ_y)
    mean_sys, var_sys = Integration.ensemble(x0,y0,params,tmax,Δt,N)
    ps_plot = Plotting.phase_space(mean_sys,params,x0,y0,tmax,Δt,N)
    savefig(ps_plot,"results/PhaseSpace_epsilonx$(ϵ_x)_epsilony$(ϵ_y)_xo$(x0)_yo$(y0)_N$N.png")
    s_plot = Plotting.stats_plot(mean_sys,params,x0,y0,tmax,Δt,N)
    savefig(s_plot,"results/Stats_epsilonx$(ϵ_x)_epsilony$(ϵ_y)_xo$(x0)_yo$(y0)_N$N.png")
    anim = Plotting.phase_space(mean_sys,params,x0,y0,tmax,Δt,N,true)
    gif(anim, "results/PhaseSpace_epsilonx$(ϵ_x)_epsilony$(ϵ_y)_xo$(x0)_yo$(y0)_N$N.gif", fps=500)
end