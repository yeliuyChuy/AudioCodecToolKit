function basic_coder(ifile)

common;
    %=================================== read input file ===================================   
    [s, samp_freq] = audioread(ifile);%get the signal vector and sampling frequency
    [~, num_chan] = size(s);%get the channel numbers
    if ( ~exist(ifile, 'file') )
        fprintf('File %s not found\n', ifile);
        return
    end
    if ( ~(samp_freq == 44100 || samp_freq == 48000) )
        fprintf('Sampling rate must be 44100 or 48000\n');
        return
    end
  
     %transient_detect.m==================================
     cw_transient_detector(s);
     %====================================================

     %init_freq_bands.m==================================
     [freq_band_top,top_band,z_max] = init_freq_bands(samp_freq,N)
     %====================================================
     
     %init_spread_ftn.m==================================
     sf_pow_band = init_spread_ftn(z_max);
     %====================================================
     
     % init_abs_thr.m==================================
     [abs_thr_bin_dB, abs_thr_band_dB] =...
        init_abs_thr(samp_freq, p0_level_dB, freq_band_top, top_band);
     %====================================================
     
     %get target block
     %n1 = 12345;
     x1 = s(n1+1:n1+N, :);
     %mc_spread.m ========================================
     windows = init_windows(0);
     win_seq = [W_LONG, 0, 0];
     [X, Xfft] = mc_mdct_fft2(x1, windows, win_seq(1)); 
     [~, ~, Xs_pow_bins,num_bands] =...
        mc_spread(Xfft, sf_pow_band, z_max, freq_band_top);
     %====================================================
     
     %mc_tonality.m ========================================
     twin = hamming(N);
     [~, SMRbins] = mc_tonality(x1.*twin, freq_band_top, num_bands,num_chan);
     %====================================================
     
    %plot results=====================================================
    %
    %plot on Hz (bin) frequency scale, up to max_freq
    %top_bin = top_band = max_freq
    top_bin = freq_band_top(top_band);
    X_dB = 20*log10(abs(X(1:top_bin,:)) + realmin);
    Xfft_dB = 20*log10(abs(Xfft(1:top_bin,:)) + realmin);
    Xs_dB = 10*log10(Xs_pow_bins(1:top_bin,:) + realmin);
    bw = samp_freq/N; %bin width, Hz
    
    figure(5)
    fs = linspace(bw/2, samp_freq/2-bw/2, N2)';
    fs = fs(1:top_bin);
    for j=1:num_chan
        subplot(num_chan,1,j)
        semilogx(fs, X_dB(:,j), 'k', fs, Xfft_dB(:,j), 'b',...
            fs, Xs_dB(:,j), 'm',...
            fs, Xs_dB(:,j)-SMRbins(1:top_bin,j), 'r',...
            fs, min(abs_thr_bin_dB(1:top_bin), 60), 'g');
        legend('MDCT', 'FFT', 'Spread', 'Thr', 'AbsThr');
        xlabel('Hz');
        ylabel('Amplitude/Magnatude');
        grid;
    end

     %[x_idx, q_bits, x_hat, max_x_idx] = quant_iquant_pmr(s,2^(-15));
end