clear all
clc
close all
% call configuration
config
mc = 1;
MC = 1;
RESULT_means = zeros (mc,6);
RESULT_medoids = zeros (mc,6);
RESULT_Fuzzy = zeros (mc,6);
[UE, MeNB, HotSpot, Grid] = create_grid(T, M, clusters, NMeNB, RMacro, RHotSpot, uheight, mheight, PtMacrodBm);
%% ****************  Before Disaster ***********************************%
plot_grid(UE, MeNB,  Grid, threshold, []);

%% ****************  50 %  Disaster ***********************************%
MeNB([1 2]) = [];
plot_grid(UE, MeNB,  Grid, threshold, []);

%% find outage ousers to be served by Drones
outageUsers = find_outage_users(UE, MeNB, threshold);
number_of_drone = ceil(length(outageUsers) / M);


[drone_ues_k_medoids]  = drone_ue_association('kmedoid', outageUsers, number_of_drone, drone_height, PtdBmDrone);
[drone_ues_k_means] = drone_ue_association('kmeans', outageUsers, number_of_drone, drone_height, PtdBmDrone);
[drone_ues_fuzzy] = drone_ue_association('Fuzzy', outageUsers, number_of_drone, drone_height, PtdBmDrone);

RUs = get_rus();

plot_grid(outageUsers, drone_ues_k_means,  Grid, threshold, RUs);
plot_grid(outageUsers, drone_ues_k_medoids,  Grid, threshold, RUs);
plot_grid(outageUsers, drone_ues_fuzzy,  Grid, threshold, RUs);



drone_ues_rates_k_means = drone_ues_rates(drone_ues_k_means)
drone_rus_rates_k_means = drone_rus_rates(drone_ues_k_means, RUs)



D = [RUs.capacity];
P =  [drone_ues_rates_k_means];
C =  [drone_rus_rates_k_means'];

% Build LP formulation (custom function you have)
lpp = offloading_cache(C, P, D);
% Solve using linprog
[xopt, fval] = linprog(-lpp.f, lpp.A, lpp.b, [], [], lpp.lb);

% Reshape into allocation matrix
xopt = reshape(xopt, lpp.s);

disp('Optimal Allocation (X):')
disp(xopt)