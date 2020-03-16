function [abs_thr_bin_dB, abs_thr_band_dB] = init_abs_thr(samp_freq, P0_level_dB, freq_band_top, top_band)

common;

fs = samp_freq;
f = linspace(0,fs/2,N2); % N2 equally spaced values from 0 to the Nyquist
abs_thr_band_dB = zeros(1,top_band);
f = f/1000;

abs_thr_bin_dB = 3.64*(f.^(-0.8)) - 6.5*exp(-0.6*((f-3.3).^2))+10.^(-3)*(f.^4);

scale_factor = abs(p0_level_dB - min(abs_thr_bin_dB));
abs_thr_bin_dB = abs_thr_bin_dB - scale_factor;

bottom_bin = 1;
    for i = 1:top_band
        top_bin = freq_band_top(i);
        abs_thr_band_dB(i) = min(abs_thr_bin_dB(bottom_bin:top_bin));
        bottom_bin = top_bin+1;
    end

ns = 1:round(N2*freq_max/(samp_freq/2));
f = f*1000;%reverse kHz to Hz

%figure(3);
%semilogx(f(ns),abs_thr_bin_dB(ns));grid;
%xlabel('Hz');
%ylabel('dB');

end