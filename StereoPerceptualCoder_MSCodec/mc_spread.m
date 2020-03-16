function      Xs_pow_bands =...
        mc_spread(X_pow_bins, sf_pow_band, z_max,fb_per_cb, freq_band_top)
    
    common;
    
    [~,num_chan] = size(X_pow_bins);
    Xs_pow_bins = zeros(Nbins,num_chan);
   
    num_bands = z_max*fb_per_cb;
    %Xpow_bands = zeros(length(freq_band_top),num_chan);
    for j = 1:num_chan
    bottom_bin = 1;
    for i =1:length(freq_band_top)
        top_bin = freq_band_top(i);
        Xpow_bands(i,j) = sum(X_pow_bins(bottom_bin:top_bin,j));
        bottom_bin = top_bin+1;   
    end
    end
   
    for j = 1:num_chan
    filtering_buf(:,j) = filter(sf_pow_band,1,[Xpow_bands(:,j)' zeros(1,num_bands)]);
    Xs_pow_bands(:,j) = filtering_buf(z_max*fb_per_cb+1:length(filtering_buf),j);%remove z_max*fb_per_cb values from the beginning of the filter output.
    end
    %======================================distribute the spread power in Xs_pow_bands over the bins
    for j = 1:num_chan
    bottom_bin = 1;
    top_band = length(freq_band_top);
    Xs_pow_bands(:,j) = Xs_pow_bands(:,j)';
    for i = 1:top_band
        top_bin = freq_band_top(i);
        Xs_pow_bins(bottom_bin:top_bin, j) = Xs_pow_bands(i, j);
        bottom_bin = top_bin+1;
    end
    end
    %figure(4);
    %cb = linspace(1/3,25,num_bands);
    %plot(cb, 10*log10(Xpow_bands(:,:)+realmin),'b',...
         %cb, 10*log10(Xs_pow_bands(:,:)+realmin),'r');grid;
    %f = linspace(0,fs/2,N2); % N2 equally spaced values from 0 to the Nyquist
    
end