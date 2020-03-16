function [freq_band_top,top_band,z_max] = init_freq_bands(samp_freq, N, fb_per_cb, freq_max)


fs = samp_freq;
bin_width = fs/N;
N2 = N/2;

f = linspace(bin_width/2,fs/2 - bin_width/2,N2); %creating vector has the values qual to the center of bins

Z_bark = 13*atan(0.76*f/1000)+3.5*atan((f/7500).^2); %bark formula caculates z(f)

if (1) 
    plot(Z_bark);grid
    xlabel('FFT bins');
    ylabel('Bark');
    pause;
end

z_max = round(max(Z_bark));

num_bands = fb_per_cb * z_max;
topBandBuf = freq_max;
    for i = 1:num_bands
        bark_i = i/fb_per_cb;
        [~,j] = min(abs(Z_bark - bark_i));
        freq_band_top(i) = j;
        fprintf('%2d %6.2f %4d %6.0f\n',i,Z_bark(j),j,j/N2*fs/2);
    
    %=============================top band=================================      
        tempValue = min(abs(freq_max - j/N2*fs/2));
        if tempValue < topBandBuf
            topBandBuf = tempValue;
            top_band = i;
        end
    end



end