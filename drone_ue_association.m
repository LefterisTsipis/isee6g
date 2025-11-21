function [Drone] = drone_ue_association(method, UE, number_of_drone, drone_heigth, PtdBm)
TableUE = struct2table(UE);
data = TableUE(:, 2:3);
data = table2array(data);

if(strcmp(method, 'kmeans'))
    [idx, C] = kmeans(data, number_of_drone);
elseif (strcmp(method, 'kmedoid'))
    [idx, C] = kmedoids(data, number_of_drone);
else
    [C, idx] = fcm(data, number_of_drone);
end

Drone=struct([]);

for i=1:number_of_drone
    Drone(i).x = C(i,1);
    Drone(i).y = C(i,2);
    Drone(i).z = drone_heigth;
    Drone(i).PtdBm = PtdBm;
    Drone(i).Pt = 10^((PtdBm-30)/10);
end

% for each UEs add the idx
for j = 1:length(UE)
    UE(j).EnB_ID = idx(j);
end


% For each drone keep its UEs to FIeld like Drone(j).UEs
for j = 1:number_of_drone
    Drone(j).UEs = UE(idx == j);

end

