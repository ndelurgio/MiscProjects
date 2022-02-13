clear
clc

% Model Properties
global M m l g K
M = 10;
m = 1;
l = 1;
g = 9.8;

% LQR for control
A = [0 1  0            0
     0 0 -m/M*g        0
     0 0  0            1
     0 0 (M+m)/(M*l)*g 0];
B = [0
     1/M
     0
     -1/(M*l)];
Q = [0.01 0    0     0
     0    0.01 0     0
     0    0    10    0
     0    0    0     0.01];
N = zeros(4,1);
R = 0.01;
K = lqr(A,B,Q,R,N);
% Initial State
x0 = [0    % p
      0    % pdot
      0.1 % theta
      0];  %thetadot

% Initialize, Run, and Plot
tspan = [0 10];
options = odeset('RelTol', 1e-9, 'AbsTol', 1e-9);
[t,x] = ode45(@pendcart, tspan, x0);
plot_sim

function xdot = pendcart(t,x,u)
u = control(x);
global M m l g
st = sin(x(3));
ct = cos(x(3));
td = x(4); %theta-dot
xdot(1,1) = x(2);
xdot(2,1) = (u + m*l*td^2*st - m*g*ct*st) / (M + m*st^2);
xdot(3,1) = td;
xdot(4,1) = (-u*ct - m*l*td^2*st*ct + g*st*(M+m)) / (M*l + m*l*st^2);
end

function u = control(x)
global K
u = K*-x;
end