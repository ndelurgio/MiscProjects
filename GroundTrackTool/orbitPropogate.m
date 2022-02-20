function nu2 = orbitPropogate(nu1,e,mu,a,TOF,k)
n = sqrt(mu/a^3);
E1 = 2*atan(sqrt((1-e)/(1+e))*tan(nu1/2));
M = n*TOF + E1 - e*sin(E1) + 2*pi*k;
E2 = kepler(M,e);
nu2 = 2*atan(sqrt((1+e)/(1-e))*tan(E2/2));

end