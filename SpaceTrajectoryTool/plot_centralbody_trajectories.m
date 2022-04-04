function plot_centralbody_trajectories(central_body,solsys,fn_solsys,spacecraft,fn_spacecraft)
m2au = 6.68459e-12; %meters to astrometrical units
figure('Name',strcat(central_body, ' Trajectory Plot'))
hold on;
centralbodysys = struct();
for k = 1:numel(fn_solsys)
    if ~strcmp(fn_solsys{k},'Sun') && strcmp(solsys.(fn_solsys{k}).central_body,central_body) 
        centralbodysys.(fn_solsys{k}) = solsys.(fn_solsys{k});
    end
end
fn_cb = fieldnames(centralbodysys);
Legend = cell(length(1:numel(fn_cb)),1);
for k = 1:numel(fn_cb)
    if isfield(solsys.(fn_cb{k}), "rv")
        plot3(solsys.(fn_cb{k}).rv(1,:)*m2au,solsys.(fn_cb{k}).rv(2,:)*m2au,solsys.(fn_cb{k}).rv(3,:)*m2au,"LineWidth",2);
        Legend{k} = "\color{white}" + fn_cb{k};
    end
end
if isfile("images\" + central_body + ".jpg")
    I = imread("images\" + central_body + ".jpg");
    [x,y,z] = sphere;              % create a sphere
    radius = solsys.(central_body).radius;
    s = surface(radius*x*m2au,radius*y*m2au,radius*z*m2au);            % plot spherical surface
    
    s.FaceColor = 'texturemap';    % use texture mapping
    s.CData = flipud(I);                % set color data to topographic data
    s.EdgeColor = 'none';          % remove edges
    s.FaceLighting = 'gouraud';    % preferred lighting for curved surfaces
    s.SpecularStrength = 0.4;      % change the strength of the reflected light
    
    light('Position',[-1 0 1])     % add a light
end
Legend = Legend(~cellfun(@isempty,Legend));
%[X, Y, Z] = sphere;
%surf(0.00465*X,0.00465*Y,0.00465*Z,'FaceColor','y');
%Legend{end+1} = "\color{white}Sun";
lgnd = legend(Legend);
%clear X Y Z
axis equal;
grid on;
xlabel('X (AU)')
ylabel('Y (AU)')
zlabel('Z (AU)')
set(gca,'Color','k')
set(gca,'GridColor','y')
set(gca,'YAxisLocation','origin')
set(gca,'XAxisLocation','origin')
set(gcf,'position',[200,100,800,800])
set(gcf,'Color','k')
set(gca,'XColor',[0.6 0.6 0.27])
set(gca,'YColor',[0.6 0.6 0.27])
set(gca,'ZColor',[0.6 0.6 0.27])
set(lgnd,'color','k')
lgnd.Title.Color = 'w';
axis auto;
maxdist = max(abs(axis));
axis([-maxdist,maxdist,-maxdist,maxdist,-maxdist,maxdist])