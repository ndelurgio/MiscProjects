function E=kepler(M,e)
E = M; %initial guess
tolerance = 1e-14;
delta_E = 1; %initialization
iterations = 0; %number of iterations
while abs(delta_E) > tolerance
    delta_E = -(M-E+e*sin(E))/(-1+e*cos(E));
    E = E + delta_E;
    iterations = iterations + 1;
    if iterations > 1000
        break
    end
end

end