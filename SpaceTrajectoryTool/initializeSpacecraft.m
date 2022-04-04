function spacecraft = initializeSpacecraft(t_epoch,t_launch,tof,solsys,planet0,planetf,centralbody,name)
spacecraft = struct;

if isfield(solsys.(planet0), "rv0") && isfield(solsys.(planetf), "rv0") && isfield(solsys.(centralbody),"mu")
    %Compute inital position
    t_launch_rel = seconds(t_launch - t_epoch);
    rv0 = propogate2body(solsys.(planet0).rv0,solsys.(centralbody).mu,t_launch_rel);
    r0 = rv0(1:3);
    %Compute final position
    rvf = propogate2body(solsys.(planetf).rv0,solsys.(centralbody).mu,t_launch_rel + tof*86400);
    rf = rvf(1:3);

    %Find the inertial velcoity vector required by the spacecraft using a
    %lambert solver

    [v0,~,~,~] = lambert(r0'*10^-3,rf'*10^-3,tof,0,solsys.(centralbody).mu*10^-9);
    spacecraft.(name).rv0 = [r0;v0'*10^3];
    spacecraft.(name).oe0 = rv2oe(spacecraft.(name).rv0,solsys.(centralbody).mu);
    spacecraft.(name).t_launch_rel = t_launch_rel;
    spacecraft.(name).tof = tof*86400;
else
    disp("Error: Planet/Central Body not found/defined")
end

% tof = 100;
% r0 = [1e8,1e7,1e6];
% rf = [-2e8,1e7,1e6];
% mu = 1.327124400189e11;
% 
% [v0,~,~,exit] = lambert(r0,rf,tof,0,mu);