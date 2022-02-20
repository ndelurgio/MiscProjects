clear
clc
close all
%% Initial Conditions
%oe = [6.680256342908875e+03,0,85,0,0,0];
oe = [15000 0.5 50 270 0 0];
thetaG0 = 0;
N = 3;
ObsLon = 262.25;
ObsLat = 30.3;

[Lat,Lon,rIJK,rECEF,AZ,EL,T] = groundTrack(oe(1),oe(2),oe(3),oe(4),oe(5),oe(6),N,thetaG0,ObsLon,ObsLat);
Lon = Lon(1:round(T/50):length(Lon));
Lat = Lat(1:round(T/50):length(Lat));
%% Repeat Ground Track
altitude = 302;
i = 85;
e = 0;
a = 301+6378;
oe2 = [a e i 0 0 0];
period = 2*pi*sqrt(a^3/3.986e5);
% Angle for swadth width is angle between two body-fixed orbits, which is
% 360/N.
%% Graphs, Plots
close all
% Part 1)
figure
hold on;

scatter(Lon,Lat,10,'red','filled');
axis equal
grid on;
xlim([-180,180]);
ylim([-90,90]);

I = imread("earth2.jpg");
h = image(xlim,-ylim,I);
uistack(h,'bottom');
xlabel("Longitude (Degrees)");
ylabel("Latitude (Degrees)");
title("Longitude/Latitude Map");
grid on;
hold off;

% Part 2
figure
hold on;
plot3(rECEF(:,1),rECEF(:,2),rECEF(:,3),"y");

[x,y,z] = sphere;              % create a sphere 
s = surface(6.378e3*x,6.378e3*y,6.378e3*z);            % plot spherical surface

s.FaceColor = 'texturemap';    % use texture mapping
s.CData = flipud(I);                % set color data to topographic data
s.EdgeColor = 'none';          % remove edges
s.FaceLighting = 'gouraud';    % preferred lighting for curved surfaces
s.SpecularStrength = 0.4;      % change the strength of the reflected light

light('Position',[-1 0 1])     % add a light

axis equal               
view([-30,30])
xlabel("X-ECEF (km)")
ylabel("Y-ECEF (km)")
zlabel("Z-ECEF (km)")
%set(gca,'Color','k')

title('ECEF Trajectory')
hold off;

% Part 3

figure
hold on;
plot3(rIJK(:,1),rIJK(:,2),rIJK(:,3),"y");

[x,y,z] = sphere;          % create a sphere 
s = surface(6.371e3*x,6.371e3*y,6.371e3*z);            % plot spherical surface

s.FaceColor = 'texturemap';    % use texture mapping
s.CData = flipud(I);           % set color data to topographic data
s.EdgeColor = 'none';          % remove edges
s.FaceLighting = 'gouraud';    % preferred lighting for curved surfaces
s.SpecularStrength = 0.4;      % change the strength of the reflected light

light('Position',[-1 0 1])     % add a light

axis equal               
view([-30,30])
xlabel("X-IJK (km)")
ylabel("Y-IJK (km)")
zlabel("Z-IJK (km)")
%set(gca,'Color','k')
title('IJK Trajectory')
hold off;

% Part 4
figure;
hold on;
plot(AZ);
plot(EL);
title("Azimuth, Elevation vs. Time")
xlabel('Time (seconds)');
ylabel('Degrees');
legend('Azimuth','Elevation')
xlim([0,N*T]);
ylim([-180,180]);
hold off;

%% Animation
%Part 5
close all
figure
hold on;
animation = VideoWriter('animation');
animation.FrameRate = 10;
open(animation)
grid on;
axis equal
xlim([-180,180]);
ylim([-90,90]);
xlabel("Longitude (Degrees)");
ylabel("Latitude (Degrees)");
imagesc([-180 180], [90 -90], I);
title("Ground Track Animation");

for i = 1:length(Lon)
    scatter(Lon(i),Lat(i),10,'filled','red');
    pause(0.01);
    frame = getframe(gcf);
    writeVideo(animation,frame);
end
close(animation)

hold off;

