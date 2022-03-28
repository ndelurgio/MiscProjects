m2au = 6.68459e-12; %meters to astrometrical units
figure('Name','Trajectory Plot')
hold on;
Legend = cell(length(1:numel(fn)),1);
for k = 1:numel(fn)
    if isfield(solsys.(fn{k}), "rv")
        plot3(solsys.(fn{k}).rv(1,:)*m2au,solsys.(fn{k}).rv(2,:)*m2au,solsys.(fn{k}).rv(3,:)*m2au,"LineWidth",2);
        Legend{k} = "\color{white}" + fn{k};
    end
end
Legend = Legend(~cellfun(@isempty,Legend));
[X, Y, Z] = sphere;
surf(0.00465*X,0.00465*Y,0.00465*Z,'FaceColor','y');
Legend{end+1} = "\color{white}Sun";
lgnd = legend(Legend);
clear X Y Z
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