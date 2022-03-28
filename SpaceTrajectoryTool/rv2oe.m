function rv2oe = rv2oe(rv,mu)

r_ijk = [rv(1);rv(2);rv(3)];
v_ijk = [rv(4);rv(5);rv(6)];

h = cross(r_ijk,v_ijk);
n = cross([0;0;1],h)/norm(cross([0;0;1],h));

a = -mu/(norm(v_ijk)^2-2*mu/norm(r_ijk)); %semi-major axis
e = cross(v_ijk,h)/mu - r_ijk/norm(r_ijk); %eccentricity
i = acos(h(3)/norm(h)); %inclination
cap_omega = atan2(n(2),n(1)); %cap_omega


true_anomoly = acos(dot(e,r_ijk)/(norm(e)*norm(r_ijk))); %true anomoly
if dot(r_ijk,v_ijk) < 0
    true_anomoly = -true_anomoly;
end

sml_omega = acos(dot(n,e)/(norm(n)*norm(e))); %sml_omega
if e(3) < 0
    sml_omega = -sml_omega;
end

rv2oe = [a;norm(e);i;sml_omega;cap_omega;true_anomoly];
for i = 3:6
    if rv2oe(i) < 0
        rv2oe(i) = rv2oe(i) + 2*pi;
    end
end
end