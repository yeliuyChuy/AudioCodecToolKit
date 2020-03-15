function [SMRbands, SMRbins] = mc_tonality(xw, freq_band_top,num_bands)
%xw is windowed signal block
    %freq_band_top is mapping from bins to Bark
    %
    %SMRbands is Signal to Mask Ratio on Bark scale
    %SMRbins is Signal to Mask Ration on Hz scale
    %
    %from common.m
    %N2, TMN and NMT
    common;
    
    SMRbands = zeros(num_bands,2);
    X_tonality = abs(fft(xw)).^2;
    
    %compute spectral flatness measures from power spectrum
    if mean(xw) == 0
        sfm = 0;
    else
        %ratio of geometric mean to arithmetic mean
        sfm = geomean(abs(X_tonality))/mean(X_tonality);
    end
    %interpolate the Signal to Mask ratio SMR between the Tone Masking Noise (TMN) value
    %and the Noise Masking Tone (NMT) 
    SMRbands(:,1) = ((1-sfm).*(TMN) + sfm.*NMT)*ones(num_bands,1);
    SMRbands(:,2) = ((1-sfm).*(TMN) + sfm.*NMT)*ones(num_bands,1);
    
    fprintf('SMR is %6.2f \n', mean(SMRbands));
    
    bottom_bin = 1;
    top_band = length(freq_band_top);
    %convert SMR from the Bark to the Hz frequency scale using freq_band_top
    for i = 1:top_band
        top_bin = freq_band_top(i);
        SMRbins(bottom_bin:top_bin, 1) = SMRbands(i, 1);
        SMRbins(bottom_bin:top_bin, 2) = SMRbands(i, 2);
        bottom_bin = top_bin+1;
    end
    
    
end