clc; clear; close all;

%% System parameters
N_users   = 3;           % number of users
N_slots   = 1000;        % number of time slots
BW        = 1e6;         % 1 MHz bandwidth
T_slot    = 1e-3;        % 1 ms per slot
Noise_PSD = -174;        % dBm/Hz (thermal noise)
Noise_Fig = 5;           % dB, receiver noise figure

%% Channel model (random SNR per user & slot)
% Average SNR per user (in dB), you can change these
avgSNR_dB = [0 5 10];    % user 1,2,3 have different average SNR

% Generate SNR for each user in each slot (Rayleigh-like variation)
snr_dB = zeros(N_users, N_slots);
for u = 1:N_users
    % Small random variation around average SNR
    snr_dB(u,:) = avgSNR_dB(u) + 5*randn(1, N_slots);
end

% Convert SNR to linear scale
snr_lin = 10.^(snr_dB/10);

%% Spectral efficiency using Shannon (approximation)
% C = BW * log2(1 + SNR)
% So spectral efficiency (bits/s/Hz): eta = log2(1 + SNR)
eta = log2(1 + snr_lin);          % [bits/s/Hz] for each user & slot

% Data rate for each user in each slot
R = BW * eta;                     % [bits/s]

% Bits that could be sent by each user in each slot
bits_possible = R * T_slot;       % [bits per slot]

%% 1) Round Robin scheduling
bits_RR = zeros(1, N_users);

for n = 1:N_slots
    % Choose user in round-robin fashion: 1,2,3,1,2,3,...
    u = mod(n-1, N_users) + 1;
    
    bits_RR(u) = bits_RR(u) + bits_possible(u, n);
end

%% 2) Max-SNR scheduling
bits_MaxSNR = zeros(1, N_users);

for n = 1:N_slots
    % Pick user with highest SNR in this slot
    [~, u] = max(snr_dB(:, n));
    
    bits_MaxSNR(u) = bits_MaxSNR(u) + bits_possible(u, n);
end

%% Show results
total_bits_RR     = sum(bits_RR);
total_bits_MaxSNR = sum(bits_MaxSNR);

fprintf('=== Total bits sent in %d slots ===\n', N_slots);
fprintf('Round Robin total bits:   %.2e\n', total_bits_RR);
fprintf('Max-SNR total bits:       %.2e\n\n', total_bits_MaxSNR);

fprintf('=== Bits per user (Round Robin) ===\n');
for u = 1:N_users
    fprintf('User %d: %.2e bits\n', u, bits_RR(u));
end

fprintf('\n=== Bits per user (Max-SNR) ===\n');
for u = 1:N_users
    fprintf('User %d: %.2e bits\n', u, bits_MaxSNR(u));
end

%% Plot comparison
figure;
subplot(1,2,1);
bar(bits_RR/1e6);
title('Round Robin: User Throughput');
xlabel('User'); ylabel('Mbits');

subplot(1,2,2);
bar(bits_MaxSNR/1e6);
title('Max-SNR: User Throughput');
xlabel('User'); ylabel('Mbits');
