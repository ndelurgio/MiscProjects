clear
clc
close all;

launch_angles = 1:90;
s0 = 26.8224; %m/s

max_dist = zeros(1,length(launch_angles));
for i = 1:length(launch_angles)
    x = projectileSim(launch_angles(i),s0);
    max_dist(i) = max(x(:,1));
end

figure
hold on;
plot(launch_angles,max_dist,'LineWidth',2);
xlabel('Launch Angle (deg)')
ylabel('Downrange Distance (m)')
title('Throw Distance vs. Launch Angle')