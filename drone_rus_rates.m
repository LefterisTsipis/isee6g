function rates = drone_rus_rates(drone_ues, rus)

    n_drones = numel(drone_ues);
    n_rus = numel(rus);

    % Create rates matrix: rows = RUs, columns = drones
    rates = zeros(n_rus, n_drones);

    % Fill with random values (example: random 1–10 Mbps)
    for i = 1:n_drones
        for u = 1:n_rus
            rates(u, i) = 1 + (10 - 1) * rand;   % random 1–10 Mbps
        end
    end

end