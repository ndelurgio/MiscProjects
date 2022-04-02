clear
clc
close all;

launch_angles = 1:0.5:90;
s0 = 15:5:50; %m/s

max_dist = zeros(length(s0),length(launch_angles));
for i = 1:length(s0)
    for j = 1:length(launch_angles)
        x = projectileSim(launch_angles(j),s0(i));
        max_dist(i,j) = max(x(:,1));
    end
end

opt_launch_ang = zeros(length(s0),1);
opt_launch_dist = zeros(length(s0),1);
for i = 1:length(s0)
    [opt_launch_dist(i), indx] = max(max_dist(i,:));
    opt_launch_ang(i) = launch_angles(indx);
end

maxdist_fit = polyfit(opt_launch_ang,opt_launch_dist,1);

figure
hold on;
for i = 1:length(s0)
    plot(launch_angles,max_dist(i,:),'LineWidth',2)
end
Legend = cell(length(s0)+1,1);
for i = 1:length(Legend)-1
    Legend{i} = 's0 = ' + string(s0(i)) + 'm/s';
end
range = min(opt_launch_ang)-1:0.1:max(opt_launch_ang)+1;
plot(range,polyval(maxdist_fit,range),'--')
Legend{end} = 'Best Fit';
legend(Legend)
set(gcf,'position',[300,300,800,600])
xlabel('Launch Angle (deg)')
ylabel('Downrange Distance (m)')
ylim([0,inf])
title('Throw Distance vs. Launch Angle')