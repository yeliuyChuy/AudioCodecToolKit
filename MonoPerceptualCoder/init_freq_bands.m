function [freq_band_top,top_band,z_max] = init_freq_bands(samp_freq, N, l_fb_per_cb, freq_max)


fs = samp_freq;
bin_width = fs/N;
N2 = N/2;

f = linspace(bin_width/2,fs/2 - bin_width/2,N2); %creating vector has the values qual to the center of bins

Z_bark = 13*atan(0.76*f/1000)+3.5*atan((f/7500).^2); %bark formula caculates z(f)

if (0) 
    plot(Z_bark);grid
    xlabel('FFT bins');
    ylabel('Bark');
    pause;
end

z_max = round(max(Z_bark));

num_bands = l_fb_per_cb * z_max;

    for i = 1:num_bands
        bark_i = i/l_fb_per_cb;
        [~,j] = min(abs(Z_bark - bark_i));
        freq_band_top(i) = j;
        fprintf('%2d %6.2f %4d %6.0f\n',i,Z_bark(j),j,j/N2*fs/2);
    end
    
    ref_f = f;
    for j = 1:length(ref_f)
        if ref_f(j) > freq_max
            ref_f(j) = 0;
        end
    end
    [max_freq,max_freq_index] = max(ref_f)
    
    
[~,top_band_index] = max(freq_band_top);
top_band = top_band_index;

end