function [Drone] = drone(method, UE, number_of_drone, drone_heigth, PtdBm)
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


