function [solsys,t0,tf] = initializeEnviornment_FullSolarSys(t_epoch,t_final)

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
[solsys.Jupiter.rv0,~] = cspice_spkezr('JUPITER BARYCENTER',t0,frame,abcorr,'SUN'); 
[solsys.Saturn.rv0,~] = cspice_spkezr('SATURN BARYCENTER',t0,frame,abcorr,'SUN'); 
[solsys.Uranus.rv0,~] = cspice_spkezr('URANUS BARYCENTER',t0,frame,abcorr,'SUN'); 
[solsys.Neptune.rv0,~] = cspice_spkezr('NEPTUNE BARYCENTER',t0,frame,abcorr,'SUN'); 
[solsys.Pluto.rv0,~] = cspice_spkezr('PLUTO BARYCENTER',t0,frame,abcorr,'SUN');
[solsys.Moon.rv0,~] = cspice_spkezr('MOON',t0,frame,abcorr,'SUN');

% Convert to meters and meters/sec
solsys.Mercury.rv0 = solsys.Mercury.rv0*1000;
solsys.Venus.rv0 = solsys.Venus.rv0*1000;
solsys.Earth.rv0 = solsys.Earth.rv0*1000;
solsys.Mars.rv0 = solsys.Mars.rv0*1000;
solsys.Jupiter.rv0 = solsys.Jupiter.rv0*1000;
solsys.Saturn.rv0 = solsys.Saturn.rv0*1000;
solsys.Uranus.rv0 = solsys.Uranus.rv0*1000;
solsys.Neptune.rv0 = solsys.Neptune.rv0*1000;
solsys.Pluto.rv0 = solsys.Pluto.rv0*1000;
solsys.Moon.rv0 = solsys.Moon.rv0*1000;

% Compute initial orbital elements for major bodies
% solsys.Mercury.oe0 = rv2oe(solsys.Mercury.rv0,solsys.Sun.mu);
% solsys.Venus.oe0 = rv2oe(solsys.Venus.rv0,solsys.Sun.mu);
% solsys.Earth.oe0 = rv2oe(solsys.Earth.rv0,solsys.Sun.mu);
% solsys.Mars.oe0 = rv2oe(solsys.Mars.rv0,solsys.Sun.mu);
% solsys.Jupiter.oe0 = rv2oe(solsys.Jupiter.rv0,solsys.Sun.mu);
% solsys.Saturn.oe0 = rv2oe(solsys.Saturn.rv0,solsys.Sun.mu);
% solsys.Uranus.oe0 = rv2oe(solsys.Uranus.rv0,solsys.Sun.mu);
% solsys.Neptune.oe0 = rv2oe(solsys.Neptune.rv0,solsys.Sun.mu);
% solsys.Pluto.oe0 = rv2oe(solsys.Pluto.rv0,solsys.Sun.mu);

% Define Planetary Masses (kg)
solsys.Sun.mass = 1.9891e30;
solsys.Mercury.mass = 3.30103e23;
solsys.Venus.mass = 4.13804e24;
solsys.Earth.mass = 5.972e24;
solsys.Mars.mass = 6.42736e23;
solsys.Jupiter.mass = 1.8985219e27;
solsys.Saturn.mass = 5.68466e26;
solsys.Uranus.mass = 8.68199e25;
solsys.Neptune.mass = 1.0243110e26;
solsys.Pluto.mass = 1.471e22;

solsys.Sun.mu = 1.327124400189e20;
solsys.Mercury.mu = 2.20329e13;
solsys.Venus.mu = 3.248599e14;
solsys.Earth.mu = 3.9860044188e14;
solsys.Mars.mu = 4.2828372e13;
solsys.Jupiter.mu = 1.266865349e17;
solsys.Saturn.mu = 3.79311879e16;
solsys.Uranus.mu = 5.7939399e15;
solsys.Neptune.mu = 6.8365299e15;
solsys.Pluto.mu = 8.719e11;
solsys.Moon.mu = 4.90486959e12;

%Define planet sizes (only for graphical purposes currently)
solsys.Sun.radius = 695508e3;
solsys.Mercury.radius = 2439e3;
solsys.Venus.radius = 6052e3;
solsys.Earth.radius = 6371e3;
solsys.Mars.radius = 3389.5e3;
solsys.Jupiter.radius = 69911e3;
solsys.Saturn.radius = 58232e3;
solsys.Uranus.radius = 25362e3;
solsys.Neptune.radius = 24622e3;
solsys.Pluto.radius = 1188.3e3;
solsys.Moon.radius = 1737.5e3;

% Define Central Body
solsys.Mercury.central_body = 'Sun';
solsys.Venus.central_body = 'Sun';
solsys.Earth.central_body = 'Sun';
solsys.Mars.central_body = 'Sun';
solsys.Jupiter.central_body = 'Sun';
solsys.Saturn.central_body = 'Sun';
solsys.Uranus.central_body = 'Sun';
solsys.Neptune.central_body = 'Sun';
solsys.Pluto.central_body = 'Sun';
solsys.Moon.central_body = 'Earth';

% Correct initial rv0 for central body
fn = fieldnames(solsys);
for k = 1:numel(fn)
    if isfield(solsys.(fn{k}),'central_body') && ~strcmp(solsys.(fn{k}).central_body,'Sun')
        solsys.(fn{k}).rv0 = solsys.(fn{k}).rv0 - solsys.(solsys.(fn{k}).central_body).rv0;
    end
end

end