function oe0 = lambert_solver(td,tof,rd,ra,mu)
n = cross(rd,ra) / (norm(rd)*norm(ra)); %orbit normal;
ca_transfer = (dot(rd,ra)/(norm(rd)*norm(ra)));

c = sqrt(norm(rd)^2 + norm(ra)^2 - 2*norm(rd)*norm(ra)*ca_transfer);

a_min = (norm(rd - ra) + norm(rd) + norm(ra))/4;
alpha_min = acos(1-(norm(rd)+norm(ra)+c)/(2*a_min));
beta_min = acos(1-(norm(rd)+norm(ra)-c)/(2*a_min));
tof_min = sqrt(a_min^3/mu)*(alpha_min - sin(alpha_min) - beta_min + sin(beta_min));
if tof_min > tof
    disp("Error: Time of Flight too small to find lambert solution")
end

syms a
alpha = acos(1-(norm(rd)+norm(ra)+c)/(2*a));
beta = acos(1-(norm(rd)+norm(ra)-c)/(2*a));
%assume(a > 0)
f = sqrt(a^3/mu)*(alpha - sin(alpha) - beta + sin(beta)) - tof;
df_da = diff(f,a);

% Compute 'a' via newton-raphson method
sma = c; % intial guess
%a = solve(f,a,'IgnoreAnalyticConstraints',true);
tolerance = 1e-8;
delta_sma = 1;
iterations = 0;
while abs(delta_sma) > tolerance
    f_sma = real(eval(subs(f,a,sma)));
    dfda_sma = real(eval(subs(df_da,a,sma)));
    delta_sma = f_sma/dfda_sma;
    sma = sma - delta_sma;
    iterations = iterations + 1;
    %disp(iterations)
    if iterations > 1000
        disp('Failed to find lambert solution')
        break;
    end
end

disp(a);
%tof = sqrt(a^3/mu)*(alpha - sin(alpha) - beta + sin(beta));
end