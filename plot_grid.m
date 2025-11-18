function plot_grid(UE, Base_station, Grid, threshold)
% 3D plot of UEs & MeNBs with serving relations

%% --- Convert UE from matrix to struct if needed ---
if ~isstruct(UE)
    UE_mat = UE;
    nUE = size(UE_mat, 1);
    UE = struct('id', [], 'x', [], 'y', [], 'z', []);
    UE = repmat(UE, nUE, 1);
    for i = 1:nUE
        UE(i).id = UE_mat(i,1);
        UE(i).x  = UE_mat(i,2);
        UE(i).y  = UE_mat(i,3);
        UE(i).z  = UE_mat(i,4);
    end
else
    nUE = numel(UE);
end

%% --- Convert Base_station from matrix to struct ---
if ~isstruct(Base_station)
    MeNB_mat = Base_station;
    nBs = size(MeNB_mat, 1);
    Base_station = struct('x', [], 'y', [], 'id', [], 'z', [], 'PtdBm', [], 'Pt', []);
    Base_station = repmat(Base_station, nBs, 1);
    for j = 1:nBs
        Base_station(j).x      = MeNB_mat(j,1);
        Base_station(j).y      = MeNB_mat(j,2);
        Base_station(j).id     = MeNB_mat(j,3);
        Base_station(j).z      = MeNB_mat(j,4);
        Base_station(j).PtdBm  = MeNB_mat(j,5);
        Base_station(j).Pt     = MeNB_mat(j,6);
    end
else
    nBs = numel(Base_station);
end

%% --- Compute serving Base_station for each UE ---
for i = 1:nUE
    for j = 1:nBs
        d = pdist([Base_station(j).x, Base_station(j).y, Base_station(j).z;
                   UE(i).x,  UE(i).y,  UE(i).z]);
        UE(i).distMeNB(j)  = d;
        UE(i).PLMeNBdB(j)  = MNLOS(d);
        UE(i).PrMenBdBm(j) = Base_station(j).PtdBm - UE(i).PLMeNBdB(j);
    end
    
    % Find max power and index
    [~, bestID] = max(UE(i).PrMenBdBm);

    % Keep best ID and best Pr
    UE(i).EnB_ID      = bestID;

    % ---- REMOVE all other values ----
    UE(i).distMeNB     = UE(i).distMeNB(bestID);
    UE(i).PLMeNBdB     = UE(i).PLMeNBdB(bestID);
    UE(i).PrMenBdBm    = UE(i).PrMenBdBm(bestID);

    if UE(i).PrMenBdBm < threshold 
        UE(i).EnB_ID = -1
    end
end

%% --- Start 3D PLOT ---
figure; hold on; grid on; box on;
title('3D UEs and MeNBs');
xlabel('X'); ylabel('Y'); zlabel('Z');
view(45,30);

%% --- 3D Plot the Grid (with Z if available) ---
rows = size(Grid.xPMeNB,1);
cols = size(Grid.xPMeNB,2);

for i = 1:rows
    if isfield(Grid,'zPMeNB')
        zvals = Grid.zPMeNB(i,:);
    else
        zvals = zeros(1,cols);  % default if Grid has no z-values
    end
    plot3(Grid.xPMeNB(i,:), Grid.yPMeNB(i,:), zvals, ...
          'b-', 'LineWidth', 2);
end

%% --- Plot Base_station (black stars) ---
xM = [Base_station.x]; 
yM = [Base_station.y]; 
zM = [Base_station.z];

plot3(xM, yM, zM, 'k*', 'MarkerSize', 12, 'LineWidth', 2);
set(gca, 'DataAspectRatio', [1 1 3]);   % Change 3 → 4, 5, etc. for more height

%% --- Plot UEs colored by serving Base_station ---
xUE = [UE.x];
yUE = [UE.y];
zUE = [UE.z];
cUE = [UE.EnB_ID];

scatter3(xUE, yUE, zUE, 40, cUE, 'filled');


%colormap(jet(nBs));
%colorbar;

axis equal;
hold off;

end
