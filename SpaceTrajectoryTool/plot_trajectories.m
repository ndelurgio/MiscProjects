m2au = 6.68459e-12; %meters to astrometrical units
figure('Name','Trajectory Plot')
hold on;
Legend = cell(length(1:numel(fn_solsys)) + length(1:numel(fn_spacecraft)),1);
for k = 1:numel(fn_solsys)
    if isfield(solsys.(fn_solsys{k}), "rv")
        plot3(solsys.(fn_solsys{k}).rv(1,:)*m2au,solsys.(fn_solsys{k}).rv(2,:)*m2au,solsys.(fn_solsys{k}).rv(3,:)*m2au,"LineWidth",2);
        Legend{k} = "\color{white}" + fn_solsys{k};
    end
end

for i = 1:numel(fn_spacecraft)
    if isfield(spacecraft.(fn_spacecraft{i}), "rv")
        plot3(spacecraft.(fn_spacecraft{i}).rv(1,:)*m2au,spacecraft.(fn_spacecraft{i}).rv(2,:)*m2au,spacecraft.(fn_spacecraft{i}).rv(3,:)*m2au,"LineWidth",2);
        Legend{k+i} = "\color{white}" + fn_spacecraft{i};
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