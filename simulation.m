% Generate the Transmitted Signal
N = 1000; % no. of samples
x_a = 2*randi([0,1],1,N)-1; % we do not want 0s, (-1, 1)
x_b = 2*randi([0,1],1,N)-1; % we do not want 0s, (-1, 1)
signal_power = 1; % Signal power (Ps)

% Calculate Noise Power
% SNR values in dB to simulate
snr_db = [-5, 0, 5, 10, 15];
error_rates = [];

%SIMULATION
for i = 1:length(snr_db)
    % Convert SNR from dB to linear scale
    snr_linear = 10^(snr_db(i)/10);

    % NOTE: snr = signal power / noise power
    noise_power = signal_power / snr_linear;
    scaling_factor = sqrt(noise_power);
    noise = randn(1, N) * scaling_factor;
    received_signal = x_a + x_b + noise;
    
    % Detection rule
    detected_signal = encode_XOR(received_signal);

    % Calculate error rate
    error_rate = sum(detected_signal ~= XOR(x_a, x_b)) / N;
    error_rates = [error_rates, error_rate];
    fprintf('SNR (dB): %d, Error Rate: %.4f\n', snr_db(i), error_rate);
    
end

% Plot Error Rate vs. SNR
figure;
semilogy(snr_db, error_rates, 'o-');
title('Error Rate vs. SNR');
xlabel('SNR (dB)');

% XOR function
function XORed_signal = XOR(a, b)
    XORed_signal = [];
    for i = 1:length(a)
        % if a not equal b
        if (a(i) ~= b(i))
            XORed_signal(i) = 1;
        % if a equal b
        else
            XORed_signal(i) = 0;
        end
    end
end

% Encoding relay into XOR function
function signal_out = encode_XOR(signal_in)
    signal_out = [];
    for i = 1:length(signal_in)
        % if 2 or -2
        if (signal_in(i) > 1) || (signal_in(i) < -1)
            signal_out(i) = 0;
        % if 0
        else
            signal_out(i) = 1;
        end
    end
end
