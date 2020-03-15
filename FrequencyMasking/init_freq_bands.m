function [freq_band_top,top_band,z_max] = init_freq_bands(samp_freq)
%map the MDCT and FFT bins to corresponding bands on the Bark scale

common;

fs = samp_freq;
bin_width = fs/N;

%create a vector f that has values equal to the center of the MDCT/FFT bins.
f = linspace(bin_width/2,fs/2 - bin_width/2,N2);

%Bark as a function of Hz:
Z_bark = 13*atan(0.76*f/1000)+3.5*atan((f/7500).^2); %bark formula 

if (1) 
    plot(Z_bark);grid
    xlabel('FFT bins');
    ylabel('Bark');
    pause;
end

z_max = round(max(Z_bark));%should be 25

num_bands = fb_per_cb * z_max;

%find the z_max*fb_per_cb values of z(bin) that are nearest to the
%1/fb_per_cb Bark divisions of the 25-Bark scale.
    for i = 1:num_bands
        bark_i = i/fb_per_cb;
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