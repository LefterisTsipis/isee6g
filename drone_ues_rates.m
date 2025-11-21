function sum_rates = drone_ues_rates(drone_ues)

    n_drones = numel(drone_ues);
    rates = cell(1, n_drones);
    sum_rates = zeros(1, n_drones);
    for i = 1:n_drones
        n_ues = numel(drone_ues(i).UEs);
        drone_rates = zeros(1, n_ues);   % vector for this drone

        for u = 1:n_ues
            drone_rates(u) = 1 + (10-1)*rand; 
        end

        % store the vector of rates for this drone
        rates{i} = drone_rates;
        sum_rates(i) = sum(rates{i});
        %drone_ues(i).total_drone_ue_rate = sum(rates{i});
    end
end