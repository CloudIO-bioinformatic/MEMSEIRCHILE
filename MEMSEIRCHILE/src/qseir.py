import numpy as np
from scipy.integrate import odeint

# Total population, N.
N = 112528.0
# Initial number of infected and recovered individuals, I0 and R0.
I0, R0 = 113.0, 63.0
# Everyone else, S0, is susceptible to infection initially.
S0 = N - I0 - R0
E0 = 0
# Contact rate, beta, and mean recovery rate, gamma, (in 1/days).
sigma, gamma, rho, mu, alpha, kappa, d = 1./5, 1./14, 2.35, 0.009799, 0.25, 396, 7.40385
beta0 = gamma * ( rho / ( sigma / sigma + mu ) )
beta = beta0 * (1 - alpha) * (1 - (d / N))**kappa

# A grid of time points (in days)
days = 365
t = np.linspace(0, days, days)

# The SIR model differential equations.
def deriv(y, t, N, beta, gamma, mu):
    S, E, I, R = y
    #print (S)
    #mu * S, si hay un transito entre comunas de forma normal, pero supondremos que 1 de cada 1000 personas lo esta haciendo
    dSdt = -beta * 0.9 * S * I / N  - ( mu * S ) / 1000
    dEdt = beta * 0.9 * S * I / N - ( sigma + mu / 1000 ) * E
    dIdt = sigma * E - ( gamma + mu / 1000 ) * I
    dRdt = gamma * I - ( mu / 1000 ) * R
    return dSdt, dEdt, dIdt, dRdt

# Initial conditions vector
y0 = S0, E0, I0, R0
# Integrate the SIR equations over the time grid, t.
ret = odeint(deriv, y0, t, args=(N, beta, gamma, mu))
S, E, I, R = ret.T

print("day\tS\tE\tI\tR")
for day in range(0,days):
    print(day,"\t",S[day],"\t",E[day],"\t",I[day],"\t",R[day])
    #print(day,"\t",R[day])
