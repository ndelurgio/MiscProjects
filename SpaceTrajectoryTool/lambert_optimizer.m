function spacecraft = lambert_optimizer(t_epoch,t_launch,tof,solsys,planet0,planetf,centralbody,name)
spacecraft = struct;

%Run a search of all queried lambert problems. spacecraft stuct stores the
%optimal dv solution to return.
for i = 1:length(t_launch)
    for j = 1:length(tof)
        sc_sol = initializeSpacecraft(t_epoch,t_launch(i),tof(j),solsys,planet0,planetf,centralbody,name);
        if i == 1 && j == 1
            spacecraft = sc_sol;
            spacecraft.EEV.dv_total = 1e9;
        else
            oe = rv2oe(sc_sol.EEV.rv0,solsys.Sun.mu);
            %Skip hyperbolas
            if oe(2) > 1
                continue;
            end
            %Compute delta-v. If improvement, set new optimal
            t_launch_rel = seconds(t_launch(i) - t_epoch);
            planet0_rv0 = propogate2body(solsys.Earth.rv0,solsys.Sun.mu,t_launch_rel);
            planetf_rvf = propogate2body(solsys.Mars.rv0,solsys.Sun.mu, t_launch_rel + tof(j)*86400);
            sc_rvf = propogate2body(sc_sol.EEV.rv0,solsys.Sun.mu,tof(j)*86400);
            dv_total = norm(sc_sol.EEV.rv0(4:6) - planet0_rv0(4:6)) + norm(sc_rvf(4:6) - planetf_rvf(4:6));
            if dv_total < spacecraft.EEV.dv_total
                spacecraft = sc_sol;
                spacecraft.EEV.dv_total = dv_total;
            end
        end
    end
end