clear all
clc

% Randomly define problem size
number_of_drones = 5;                 % supply nodes
number_of_ground_base_station = 2;     % demand nodes

% Random cost (channel gain) matrix
Chanel_gains = randi([-5 5], number_of_drones, number_of_ground_base_station); 

% Random supply and demand
P = randi([20 100], 1, number_of_drones);   
D = randi([20 100], 1, number_of_ground_base_station);  
% Balance supply and demand
totalSupply = sum(P);
totalDemand = sum(D);


if totalDemand < totalSupply
% Display results in a clearer way
fprintf('\n=== Problem Setup ===\n');

fprintf('\nChannel Gains (Cost Matrix):\n');
disp(Chanel_gains)

fprintf('\nDrone Supply (Number of Packets to Send) [Mbps]:\n');
for i = 1:length(P)
    fprintf('  Drone %d: %d Mbps\n', i, P(i));
end

fprintf('\nBase Station Demand (Packets to Receive) [Mbps]:\n');
for j = 1:length(D)
    fprintf('  Base Station %d: %d Mbps\n', j, D(j));
end

% Build LP formulation (custom function you have)
lpp = offloading_cache(Chanel_gains, P, D);

% Solve using linprog
[xopt, fval] = linprog(-lpp.f, lpp.A, lpp.b, [], [], lpp.lb);

% Reshape into allocation matrix
xopt = reshape(xopt, lpp.s);

disp('Optimal Allocation (X):')
disp(xopt)

disp('Total Cost (Chanel_gains .* X):')
disp(Chanel_gains .* xopt)

disp('Objective Value (Total Cost):')
disp(fval)

else
    fprintf('No optimizaation needed');
end
