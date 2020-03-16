function [SMRbands,SMRbins] = mc_tonality(X_pow_bins, freq_band_top,num_bands,num_chan)

% SMR_dB_bands = mc_tonality(X_pow_bins, freq_band_top);

common;
    
    SMRbands = zeros(num_bands,num_chan);
%it is already power spectrum!
%     X_tonality = abs(fft(X_pow_bins)).^2;
    
    if mean(X_pow_bins) == 0
        sfm = 0;
        else
%         sfm = geomean(abs(X_tonality))/mean(X_tonality);
        sfm = geomean(X_pow_bins)/mean(X_pow_bins);
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