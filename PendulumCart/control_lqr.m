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
     0    0    0     5];
N = zeros(4,1);
R = 0.01;
K = lqr(A,B,Q,R,N);