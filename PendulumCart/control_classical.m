% A, B, C, Dlinear matrices for full state feedback
A = [0 1  0            0
     0 0 -m/M*g        0
     0 0  0            1
     0 0 (M+m)/(M*l)*g 0];
B = [0  
     1/M
     0
     -1/(M*l)];
C = [0,0,0,0;
     0,0,0,0;
     0,0,1,0;
     0,0,0,0];
D = zeros(4,1);
sys_ss = ss(A,B,C,D);
sys_tf = tf(sys_ss);

bode(sys_ss);