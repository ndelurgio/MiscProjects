function [solsys,t0,tf] = initializeEnviornment_InnerPlanets(t_epoch,t_final)

% CREATE SOLAR SYSTEM USING SPICE (Kernals:
% https://naif.jpl.nasa.gov/pub/naif/generic_kernels/spk/planets/aa_summaries.txt)
cspice_furnsh('kernals/de432s.bsp')
cspice_furnsh('kernals/naif0012.tls')
t0 = cspice_str2et(char(t_epoch));
tf = cspice_str2et(char(t_final));

frame = 'ECLIPJ2000';
abcorr = 'NONE';

solsys = struct();
[solsys.Mercury.rv0,~] = cspice_spkezr('MERCURY BARYCENTER',t0,frame,abcorr,'SUN'); 
[solsys.Venus.rv0,~] = cspice_spkezr('VENUS BARYCENTER',t0,frame,abcorr,'SUN'); 
[solsys.Earth.rv0,~] = cspice_spkezr('EARTH',t0,frame,abcorr,'SUN');
[solsys.Mars.rv0,~] = cspice_spkezr('MARS BARYCENTER',t0,frame,abcorr,'SUN'); 

% Convert to meters and meters/sec
solsys.Mercury.rv0 = solsys.Mercury.rv0*1000;
solsys.Venus.rv0 = solsys.Venus.rv0*1000;
solsys.Earth.rv0 = solsys.Earth.rv0*1000;
solsys.Mars.rv0 = solsys.Mars.rv0*1000;


% Compute initial orbital elements
solsys.Sun.mu = 1.327124400189e20;
solsys.Mercury.oe0 = rv2oe(solsys.Mercury.rv0,solsys.Sun.mu);
solsys.Venus.oe0 = rv2oe(solsys.Venus.rv0,solsys.Sun.mu);
solsys.Earth.oe0 = rv2oe(solsys.Earth.rv0,solsys.Sun.mu);
solsys.Mars.oe0 = rv2oe(solsys.Mars.rv0,solsys.Sun.mu);

% Define Planetary Masses (kg)
solsys.Sun.mass = 1.9891e30;
solsys.Mercury.mass = 3.30103e23;
solsys.Venus.mass = 4.13804e24;
solsys.Earth.mass = 5.972e24;
solsys.Mars.mass = 6.42736e23;

solsys.Sun.mu = 1.327124400189e20;
solsys.Mercury.mu = 2.20329e13;
solsys.Venus.mu = 3.248599e14;
solsys.Earth.mu = 3.9860044188e14;
solsys.Mars.mu = 4.2828372e13;

%Define planet sizes (only for graphical purposes currently)
solsys.Sun.radius = 695508e3;
solsys.Mercury.radius = 2439e3;
solsys.Venus.radius = 6052e3;
solsys.Earth.radius = 6371e3;
solsys.Mars.radius = 3389.5e3;

% Define Central Body
solsys.Mercury.central_body = 'Sun';
solsys.Venus.central_body = 'Sun';
solsys.Earth.central_body = 'Sun';
solsys.Mars.central_body = 'Sun';

end