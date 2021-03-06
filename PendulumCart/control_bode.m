close all;
s = tf('s');

%Control Law
Kp = -189;
Kd = -52;
Ki =  0;

PID_tf = Kp + Kd*s + Ki/s;

%{
ztheta = 1;
ptheta = 2;
zomega = 1;
pomega = 2;

Gctheta = Kp*(s - ztheta)/(s - ptheta);
Gcomega = Kd*(s - zomega)/(s - pomega);
%}

% A, B, C, Dlinear matrices for full state feedback
A = [0 1  0            0
     0 0 -m/M*g        0
     0 0  0            1
     0 0 (M+m)/(M*l)*g 0];
B = [0  
     1/M
     0
     -1/(M*l)];
C = [0,0,1,0];
D = zeros(1,1);
sys_ss = ss(A,B,C,D);
sys_tf = tf(sys_ss);

%J =1/3*m*l^2;
%sys_tf = m*l / ((m^2*l^2 - (M+m)*(J+m*l^2))*s^2 + (M+m)*m*g*l)

%close_loop_tf_theta = PID_tf*sys_tf / (1 + PID_tf*sys_tf)
close_loop_tf_theta = feedback(PID_tf*sys_tf,1)
open_loop_tf_theta = PID_tf*sys_tf

[GM,PM] = margin(open_loop_tf_theta);
[mag,phase,wout] = bode(open_loop_tf_theta);

mag = reshape(mag,[length(mag(1,1,:)),1]);
phase = reshape(phase,[length(phase(1,1,:)),1]);
%{
figure
bode(sys_tf(3))
title("Bode Diagram for \theta")

figure
bode(sys_tf(4))
title("Body Diagram for \omega")


tf_theta = Gctheta*sys_tf(3);
tf_omega = Gcomega*sys_tf(4);

[mag_theta,phase_theta,w_theta] = bode(tf_theta);
[mag_omega,phase_omega,w_omega] = bode(tf_theta);

mag_theta = reshape(mag_theta,length(mag_theta(1,1,:)),1);
phase_theta = reshape(phase_theta,length(phase_theta(1,1,:)),1);
mag_omega = reshape(mag_omega,length(mag_omega(1,1,:)),1);
phase_omega = reshape(phase_omega,length(phase_omega(1,1,:)),1);

figure
G_closed_loop_theta = sys_tf(3)/(1+sys_tf(3))
rlocus(G_closed_loop_theta)
figure
plot(mag_theta,phase_theta)
%}

figure
bode(close_loop_tf_theta)
%bode(PID_tf*sys_tf(3))
title("Bode Diagram for \theta with controller")

figure
nyquist(close_loop_tf_theta)
%bode(PID_tf*sys_tf(3))
title("Nyquist Diagram for \theta with controller")

%figure
%plot(phase,mag)

%{
figure
bode(tf_omega)
title("Bode Diagram for \omega with gain matrix K")
%}

K = [0 0 Kp Kd];