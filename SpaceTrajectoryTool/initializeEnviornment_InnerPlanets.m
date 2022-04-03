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


end