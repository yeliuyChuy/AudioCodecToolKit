function test_percep_model(ifile, start_sample)
%function test_percep_model(ifile, start_sample)
%usage: test_percep_model(?horn23_1.wav', 60000)
%ifile is input file
%start_sample is first sample of signal block to
%pass to perceptual model

%Note
%bin_width = fs/N = 23.4375 = 48000/2048
%center freq of bin n (indexed from 1) is 
%   = bin_width/2 + bin_width*(n-1) or
%   = (fs/N)*(n-1/2)

    %coder parameters
    common;

    %read input file
    if ( ~exist(ifile, 'file') )
        fprintf('File %s not found\n', ifile);
        return
    end
    [s, samp_freq] = audioread(ifile);
    if ( ~(samp_freq == 44100 || samp_freq == 48000) )
        fprintf('Sampling rate must be 44100 or 48000\n');
        return
    end
    [~, num_chan] = size(s);

    %
    %initialize parameters
    %
    n1 = start_sample;
    
    %create windows
    windows = init_windows(0);
    win_seq = [W_LONG, 0, 0];

    %tonality window
    twin = hamming(N);

    %create freq_bands as 1/3 critical bands
    %freq_band_top is mapping from bins to Bark
    %top_band is top Bark band to code
    %z_max is maximum critical band
    [freq_band_top, top_band, z_max] = init_freq_bands(samp_freq);
    
    %initialize spreading function
    %z_max is maximum number of Bark bands
    %sf_pow_band is spreading function as power on Bark scale
    sf_pow_band = init_spread_ftn(z_max);
    
    %Initialize Absolute Threshold 
    %p0_level_dB is noise floor of input signal
    %freq_band_top is mapping from bins to Sark
    %top_band is top freq_band to code
    %
    %abs_thr_bin_dB is absolute threshold in dB on Hz scale
    %abs_thr_band_dB is absolute threshold in dB on Bark scale
    [abs_thr_bin_dB, abs_thr_band_dB] =...
        init_abs_thr(samp_freq, p0_level_dB, freq_band_top, top_band);
    
    %get target block
    x1 = s(n1+1:n1+N, :);

    %{
    Follow the steps of building Psychoacoustic Model
    %}
    
    %
    %window and compute mdct and FFT
    [X, Xfft] = mc_mdct_fft2(x1, windows, win_seq(1));    
    
    %spread spectrum
    %Xfft is FFT spectrum from bin 1 to N2
     %sf_pow_band is spread spectrum
     %z_max is maximum critical band
     %freq_band_top is mapping from bins to Bark
     %
     %Xpow_bands is FFT power spectrum on Bark scale
     %Xs_pow_bands is spread power spectrum on Bark scale
     %Xs_pow_bins is spread power spectrum on Hz scale
    [~, ~, Xs_pow_bins,num_bands] =...
        mc_spread(Xfft, sf_pow_band, z_max, freq_band_top);
    
    %compute tonality
    [~, SMRbins] = mc_tonality(x1.*twin, freq_band_top, num_bands);

    %
    %plot results
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
end


