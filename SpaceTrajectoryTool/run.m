clear
clc
close all;

%% CONFIG
t_epoch = datetime('now');
t_final = t_epoch + days(2000);
dt = 86400; % time step in seconds

% Create Enviornment
[solsys, t0, tf] = initializeEnviornment(t_epoch,t_final);

fn = fieldnames(solsys);
%% Run Simulation
tspan = t0:dt:tf; %create time vector for outer for loop

%create empty rv vectors for each propogatable object
for k = 1:numel(fn)
    if isfield(solsys.(fn{k}), "rv0")
        solsys.(fn{k}).rv = zeros(6,length(tspan));
        solsys.(fn{k}).rv(:,1) = solsys.(fn{k}).rv0;
    end
    if isfield(solsys.(fn{k}), "oe0")
        solsys.(fn{k}).oe = zeros(6,length(tspan));
        solsys.(fn{k}).oe(:,1) = solsys.(fn{k}).oe0;
    end
end

% propogate for each time step
for i = 1:length(tspan)
    for k = 1:numel(fn)
        % If a solar system field has orbital elements, propogate.
        % Otherwise, do nothing.
        if isfield(solsys.(fn{k}), "oe0")
            %Extract needed elements from fields
            oe0 = solsys.(fn{k}).oe0;
            nu0 = oe0(6);
            e = oe0(2);
            a = oe0(1);
            %Compute true anomoly at timestep i
            nui = orbitPropogate_analytic(nu0,e,solsys.Sun.mu,a,tspan(i));
            oei = [oe0(1:5); nui];
            solsys.(fn{k}).oe(:,i) = oei;
            %Convert to rv state vector
            rvi = oe2rv(oei,solsys.Sun.mu);
            solsys.(fn{k}).rv(:,i) = rvi;
        else
            continue;
        end
    end
end

%% ANALYSIS

% Plot results
plot_trajectories;
