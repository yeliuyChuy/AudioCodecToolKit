function     [Xpow_bands, Xs_pow_bands, Xs_pow_bins,num_bands] =...
        mc_spread(Xfft, sf_pow_band, z_max, freq_band_top);
    
    common;
    %fs= samp_freq;
    num_bands = fb_per_cb * z_max;
    Xbuf = zeros(1,length(freq_band_top));
    Xs_pow_bins = zeros(Nbins,2);
    
    
    bottom_bin = 1;
    for i =1:length(freq_band_top)
        top_bin = freq_band_top(i);
        Xbuf(i) = max(Xfft(bottom_bin:top_bin));%====???max or min
        bottom_bin = top_bin+1;   
    end
    
    Xfft_abs = abs(Xbuf);
    Xpow_bands = Xfft_abs.^2;
    
    temp_buf = zeros(1,z_max*fb_per_cb );
    filtering_buf = [Xpow_bands,temp_buf];% add z_max*fb_per_cb zeros to end of the filter input.
    filtering_buf = filter(sf_pow_band,4,filtering_buf);
    Xs_pow_bands = filtering_buf(z_max*fb_per_cb+1:length(filtering_buf));%remove z_max*fb_per_cb values from the beginning of the filter output.
    
    %======================================distribute the spread power in Xs_pow_bands over the bins
    bottom_bin = 1;
    top_band = length(freq_band_top);
    Xs_pow_bands = Xs_pow_bands';
    for i = 1:top_band
        top_bin = freq_band_top(i);
        Xs_pow_bins(bottom_bin:top_bin, :) = Xs_pow_bands(i, :);
        bottom_bin = top_bin+1;
    end
    
    figure(4);
    cb = linspace(1/3,25,num_bands);
    plot(cb, 10*log10(Xpow_bands(:,:)+realmin),'b',...
         cb, 10*log10(Xs_pow_bands(:,:)+realmin),'r');grid;
    %f = linspace(0,fs/2,N2); % N2 equally spaced values from 0 to the Nyquist
    ylabel('dB');
    xlabel('Bark');
    
end