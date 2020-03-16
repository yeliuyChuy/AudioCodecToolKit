function [SMRbands,SMRbins] = mc_tonality(X_pow_bins, freq_band_top,fb_per_cb,z_max)

% SMR_dB_bands = mc_tonality(X_pow_bins, freq_band_top);

    common;
    [~, num_chan] = size(X_pow_bins);
    
    num_bands = fb_per_cb * z_max;
    
    %SMRbands = zeros(num_bands,num_chan)
    %X_tonality = abs(fft(X_pow_bins)).^2;
    
    if mean(X_pow_bins) == 0
        sfm = 0;
        else
        sfm = geomean(X_pow_bins)/mean(X_pow_bins);%<=abs() removed
    end
    
    for j = 1:num_chan
    SMRbands(:,j) = ((1-sfm).*(TMN) + sfm.*NMT)*ones(num_bands,1);
    
    %fprintf('SMR is %6.2f \n', mean(SMRbands));
    
    bottom_bin = 1;
    top_band = length(freq_band_top);
    for i = 1:top_band
        top_bin = freq_band_top(i);
        SMRbins(bottom_bin:top_bin, j) = SMRbands(i, j);
        bottom_bin = top_bin+1;
    end
    
    end
    
    
end