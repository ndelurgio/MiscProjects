function oe2rv = oe2rv(oe,mu)

a = oe(1);
e = oe(2);
i = oe(3);
sml_omega = oe(4);
cap_omega = oe(5);
true_anomoly = oe(6);

p = a*(1-e^2);
r_magnitude = p/(1+e*cos(true_anomoly));

% Orbital Elements to Perifocal Frame
r_perifocal = [r_magnitude*cos(true_anomoly); r_magnitude*sin(true_anomoly); 0];
v_perifocal = [-sin(true_anomoly)*sqrt(mu/p); sqrt(mu/p)*(e+cos(true_anomoly)); 0];

% Perifocal Frame to Fundamental Frame from 3-1-3 Rotation
R3_cap_omega = [cos(cap_omega) -sin(cap_omega) 0
                sin(cap_omega)  cos(cap_omega) 0
                0                0               1];
            
R1_i =         [1                0               0
                0                cos(i)        -sin(i)
                0                sin(i)         cos(i)];

R3_sml_omega=  [cos(sml_omega) -sin(sml_omega) 0
                sin(sml_omega)  cos(sml_omega) 0
                0               0              1];

R = R3_cap_omega*R1_i*R3_sml_omega;

r_ijk = R*r_perifocal;
v_ijk = R*v_perifocal;

oe2rv = [r_ijk; v_ijk];

end