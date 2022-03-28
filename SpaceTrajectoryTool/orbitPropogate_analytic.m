function nu2 = orbitPropogate_analytic(nu1,e,mu,a,TOF)
n = sqrt(mu/a^3);
E1 = 2*atan(sqrt((1-e)/(1+e))*tan(nu1/2));
M = n*TOF + E1 - e*sin(E1);
M = mod(M,2*pi);
E2 = kepler(M,e);
nu2 = 2*atan(sqrt((1+e)/(1-e))*tan(E2/2));

end