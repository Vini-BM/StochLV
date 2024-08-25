module Integration

using StochLV: TimeSeries, Params
using Random
using Statistics

"Makes one integration step using Heun's method."
function heun_step!(sys::TimeSeries,params::Params,noise::TimeSeries,Δt,i::Int)

    # Unpacking
    (;a,b,c,f,ϵ_x,ϵ_y) = params
    (;x,y) = sys
    ΔW_x = noise.x
    ΔW_y = noise.y

    # Method
    k1_x = x[i]*(a - b*y[i] + (ϵ_x^2)/2)
    k1_y = y[i]*(-c + f*x[i] + (ϵ_y^2)/2)
    k2_x = (x[i] + k1_x*Δt)*(a - b*(y[i] + k1_y*Δt) + (ϵ_x^2)/2)
    k2_y = (y[i] + k1_y*Δt)*(-c + f*(x[i] + k1_x*Δt) + (ϵ_y^2)/2)

    # New variables
    new_x = x[i] +(k1_x + k2_x)*0.5*Δt + ϵ_x*x[i]*ΔW_x[i]
    new_y = y[i] + (k1_y + k2_y)*0.5*Δt - ϵ_y*y[i]*ΔW_y[i]

    # Update variables
    if new_x < 0
        sys.x[i+1] = 0
    else
        sys.x[i+1] = new_x
    end
    if new_y < 0
        sys.y[i+1] = 0
    else
        sys.y[i+1] = new_y
    end

end

"Integrates the system from initial condition to tmax."
function integrate(x0, y0, params::Params, tmax, Δt)

    # Initialization
    num_steps = floor(Int64, tmax/Δt) # number of steps
    rng = MersenneTwister()
    ΔW_x = sqrt(Δt)*randn(rng, num_steps) # Wiener increment for x
    ΔW_y = sqrt(Δt)*randn(rng, num_steps) # Wiener for y
    noise = TimeSeries(x=ΔW_x,y=ΔW_y)
    sys = TimeSeries(x=zeros(num_steps), y=zeros(num_steps))

    # Set initial conditions
    sys.x[1] = x0
    sys.y[1] = y0
    
    # Time loop
    for i in 1:num_steps-1
        heun_step!(sys,params,noise,Δt,i)
    end
    
    return sys
end

"Integrate N realizations of the system."
function ensemble(x0, y0, params::Params, tmax, Δt, N::Int64)

    num_steps = floor(Int64, tmax/Δt)

    # Matrices: store variables of each realization for each time step 
    X = zeros(N, num_steps)
    Y = zeros(N, num_steps)

    # Time series for mean and variance
    mean_sys = TimeSeries(x=zeros(num_steps),y=zeros(num_steps))
    var_sys = TimeSeries(x=zeros(num_steps),y=zeros(num_steps))

    # Loop over realizations
    for n in 1:N
        n_sys = integrate(x0,y0,params,tmax,Δt)
        X[n,:] = n_sys.x
        Y[n,:] = n_sys.y
    end

    # Loop over time
    for t in 1:num_steps
        mean_sys.x[t] = mean(X[:, t])
        mean_sys.y[t] = mean(Y[:, t])
        var_sys.x[t] = var(X[:,t])
        var_sys.y[t] = var(Y[:,t])
    end

    return mean_sys, var_sys
end

end