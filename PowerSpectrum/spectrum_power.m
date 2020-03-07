%{
1.Use Matlab Function pwelch(x) to plot the magnitude spectrum for the signal
2.Plot the envelop of the power specturm
%}
%% Plot the magnitude spectrum for the entire signal
function spectrum_power(ifile)
[x, fs] = audioread(ifile);%loading audio

%split left and right channels
left_chan = x(:,1);
right_chan = x(:,2);

figure(2)
subplot(1,1,1);
pwelch(x);
title('Welch Power Spectral Density Estimate');
xlabel('Normalized Frequency (x pi rad/sample)');
ylabel('Power/frequnecy (dB/rad/sample)');

% Compute the envelope of the power spectrum
Pxx = pwelch(x);

fprintf('CR to continue\n'); pause

[num_bins, num_chan] = size(Pxx); %num_bins = 65k, num_chan = 2
num_env_bins = 64; % 64 envelope bins 
bins_in_avg = floor(num_bins/num_env_bins); % = 1024

Penv = zeros(num_env_bins,2);
env_idx = 1

for i = 1:num_env_bins
    
    Penv(i, 1) = sqrt(mean(Pxx(env_idx:env_idx+bins_in_avg ,1) .^2));
    Penv(i, 2) = sqrt(mean(Pxx(env_idx:env_idx+bins_in_avg ,2) .^2));
    
    env_idx = env_idx + bins_in_avg;

end

freq = [0:num_env_bins-1]/num_env_bins*fs/2;

PenvdB = 10*log10(Penv);
PenvdB = PenvdB - max(max(PenvdB));

figure (3)
subplot(1,1,1)
plot(freq, PenvdB);
title('Spectrum');
xlabel('Frequency');
ylabel('dB');