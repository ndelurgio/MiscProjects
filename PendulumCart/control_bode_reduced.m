close all;
s = tf('s');

%Control Law
Kp = -250;
Kd = -80;

PID_tf = Kp + Kd*s;
%{
Ar = [0, 1; (M+m)/(M*l)*g, 0];
Br = [0;-1/(M*l)];
Cr = [1,0];
Dr = 0;

sys_ss = ss(Ar,Br,Cr,Dr);
sys_tf = tf(sys_ss)
%}

sys_tf = -1 / (s^2 - (M+m)/(M*l)*g*s)

tf_closed = PID_tf*sys_tf(1)/(1+PID_tf*sys_tf(1));

figure
bode(tf_closed)
title("Bode Diagram for \theta with Controller")

K = [0 0 Kp Kd];