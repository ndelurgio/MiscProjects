function [lat,lon,rIJK,rECEF,AZ,EL,T] = groundTrack(a,e,i,omega,LAN,nu0,N,thetaG0,ObsLon,ObsLat)
w_body = 2*pi/86164;
mu = 3.986e5;
i = i*pi/180;
omega = omega*pi/180;
LAN = LAN*pi/180;
thetaG0 = thetaG0*pi/180;
ObsLon = ObsLon*pi/180;
ObsLat = ObsLat*pi/180;

dt = 1;
T = 2*pi*sqrt(a^3/mu);

rIJK = zeros(1,3);
rECEF = zeros(1,3);
rSEZ = zeros(1,3);
R_earth_SEZ = [0 0 6378];
lat = zeros(1,1);
lon = zeros(1,1);
R_ECEF_SEZ = inv(R3(-ObsLon)*R2(ObsLat-pi/2));
AZ = zeros(1,1);
EL = zeros(1,1);

for j = 1:N*T/dt
    nu = orbitPropogate(nu0,e,mu,a,j*dt,floor(j*dt/T));
    rv_ijk = oe2rv([a,e,i,omega,LAN,nu],mu);
    rIJK(j,:) = rv_ijk(1:3);
    rECEF(j,:) = R3(w_body*j*dt+thetaG0)*rIJK(j,:)';
    
    r_mag = norm(rECEF(j,:));
    lat(j) = 180/pi*asin(rECEF(j,3)/r_mag);
    lon(j) = 180/pi*atan2(rECEF(j,2),rECEF(j,1));
    
    rSEZ(j,:) = R_ECEF_SEZ*rECEF(j,:)';
    rho(j,:) = rSEZ(j,:)-R_earth_SEZ;
    EL(j,1) = 180/pi*asin(rho(j,3)/norm(rho(j,:)));
    AZ(j,1) = 180/pi*atan2(rho(j,2),-rho(j,1));
    
end

end


function R3 = R3(x)
R3 = [cos(x) sin(x) 0
      -sin(x)  cos(x) 0
      0       0      1];
end

function R2 = R2(x)
R2 = [cos(x) 0  -sin(x)
      0      1   0
      sin(x) 0   cos(x)];
end