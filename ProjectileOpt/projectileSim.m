function x = projectileSim(launch_angle,s0)
global m rho Cd A g
m = 0.43; %kg
rho = 1.225; %kg/m^3
Cd = 0.2;
A = 0.023205; %m^2
g = [0;-9.8];

v0 = [s0*cosd(launch_angle);
      s0*sind(launch_angle)];

x0 = [0;0;v0]; % [x-pos,y-pos,vx-pos,vy-pos]
tspan = [0:0.01:30];
opt = odeset('Events',@terminate);

[t,x] = ode45(@dynamics, tspan, x0,opt);

end


function xdot = dynamics(t,x)
    xdot = zeros(4,1);

    xdot(1) = x(3);
    xdot(2) = x(4);


    global m rho Cd A g
    
    q = 0.5*rho*norm(x(3:4))^2;
    F_drag = q*A*Cd*-x(3:4)/norm(x(3:4));
    F_grav = m*g;

    xdot(3:4) = (F_drag + F_grav) / m;

end

function [value,isterminal,direction] = terminate(t,x)
    value = x(2);
    isterminal = 1;
    direction = 0;
end