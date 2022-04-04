clear
clc
close all;

%% CONFIG
t_epoch = datetime(2039,8,1);
t_final = t_epoch + days(300);
dt = 86400; % time step in seconds

% Create Enviornment
[solsys, t0, tf] = initializeEnviornment_InnerPlanets(t_epoch,t_final);
tspan = t0:dt:tf; %create time vector for outer for loop
disp('Enviornment Created...')

% Spacecraft Trajectory
%if tof and t_launch are vectors are vectors, run optimizer. Otherwise, use
%the provided solution.

tof = 100:250;
t_launch = t_epoch + days(0:160);
%tof = 141; %days
%t_launch = t_epoch + days(10);

start_planet = 'Earth';
end_planet = 'Mars';
central_body = 'Sun';
spacecraft_name = 'EEV';
spacecraft = lambert_optimizer(t_epoch,t_launch,tof,solsys,start_planet,end_planet,central_body,spacecraft_name);
disp('Spacecraft Trajectory Computed...')

fn_solsys = fieldnames(solsys);
fn_spacecraft = fieldnames(spacecraft);
%% Run Simulation
disp('Running Simulation...')

%create empty rv vectors for each propogatable object
for k = 1:numel(fn_solsys)
    if isfield(solsys.(fn_solsys{k}), "rv0")
        solsys.(fn_solsys{k}).rv = zeros(6,length(tspan));
        solsys.(fn_solsys{k}).rv(:,1) = solsys.(fn_solsys{k}).rv0;
    end
    if isfield(solsys.(fn_solsys{k}), "oe0")
        solsys.(fn_solsys{k}).oe = zeros(6,length(tspan));
        solsys.(fn_solsys{k}).oe(:,1) = solsys.(fn_solsys{k}).oe0;
    end
end

for k = 1:numel(fn_spacecraft)
    stop_time = spacecraft.(fn_spacecraft{k}).tof;
    spacecraft.(fn_spacecraft{k}).tspan = 0:dt:stop_time;
    if isfield(spacecraft.(fn_spacecraft{k}), "rv0")
        spacecraft.(fn_spacecraft{k}).rv = zeros(6,length(spacecraft.(fn_spacecraft{k}).tspan));
        spacecraft.(fn_spacecraft{k}).rv(:,1) = spacecraft.(fn_spacecraft{k}).rv0;
    end
    if isfield(spacecraft.(fn_spacecraft{k}), "oe0")
        spacecraft.(fn_spacecraft{k}).oe = zeros(6,length(spacecraft.(fn_spacecraft{k}).tspan));
        spacecraft.(fn_spacecraft{k}).oe(:,1) = spacecraft.(fn_spacecraft{k}).oe0;
    end
end

% propogate for each time step
for i = 1:length(tspan)
    %First Propogate Natural Bodies
    for k = 1:numel(fn_solsys)
        % If a solar system field has a state, propogate.
        % Otherwise, do nothing.
        if isfield(solsys.(fn_solsys{k}), "rv0")
            %Extract needed elements from fields
            rv0 = solsys.(fn_solsys{k}).rv0;
            rvi = propogate2body(rv0,solsys.(solsys.(fn_solsys{k}).central_body).mu,tspan(i));
            solsys.(fn_solsys{k}).rv(:,i) = rvi;
            if isfield(solsys.(fn_solsys{k}), "oe")
                solsys.(fn_solsys{k}).oe(:,i) = rv2oe(rvi,solsys.Sun.mu);
            end
        end
    end
end

% Second, Propogate all spacecraft in the simulation
for k = 1:numel(fn_spacecraft)
    %start_time = spacecraft.(fn_spacecraft{k}).t_launch_rel;
    stop_time = spacecraft.(fn_spacecraft{k}).tof;
    tspan_sc = spacecraft.(fn_spacecraft{k}).tspan;
    for i = 1:length(tspan_sc)
        rv0 = spacecraft.(fn_spacecraft{k}).rv0;
        rvi = propogate2body(rv0,solsys.Sun.mu,tspan_sc(i));
        spacecraft.(fn_spacecraft{k}).rv(:,i) = rvi;
        if isfield(spacecraft.(fn_spacecraft{k}),"oe")
                spacecraft.(fn_spacecraft{k}).oe(:,i) = rv2oe(rvi,solsys.Sun.mu);
        end
    end
    %spacecraft.(fn_spacecraft{k}).rv = spacecraft.(fn_spacecraft{k}).rv(spacecraft.(fn_spacecraft{k}).rv ~= 0);
end
disp('Complete')
%% ANALYSIS

% Plot results
plot_solsys_trajectories;
plot_centralbody_trajectories('Earth',solsys,fn_solsys,spacecraft,fn_spacecraft);
