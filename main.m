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
plot_grid(UE, MeNB,  Grid, threshold)

%% ****************  50 %  Disaster ***********************************%
MeNB([1 2]) = [];
plot_grid(UE, MeNB,  Grid, threshold);

%% find outage ousers to be served by Drones
outageUsers = find_outage_users(UE, MeNB, threshold);
% Total number of clusters
number_of_drone = ceil(length(outageUsers) / M);
drone_k_medoids = drone('kmedoid', outageUsers, number_of_drone, drone_height, PtdBmDrone)
drone_k_means = drone('kmeans', outageUsers, number_of_drone, drone_height, PtdBmDrone)
drone_fuzzy = drone('Fuzzy', outageUsers, number_of_drone, drone_height, PtdBmDrone)

plot_grid(outageUsers, drone_k_means,  Grid, threshold);
plot_grid(outageUsers, drone_k_medoids,  Grid, threshold);
plot_grid(outageUsers, drone_fuzzy,  Grid, threshold);

