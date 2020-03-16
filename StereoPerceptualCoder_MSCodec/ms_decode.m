function  Y =  ms_decode(Y, ms_flags, freq_band_top)

% Y(k+1:k+Nc,:) =  ms_decode(Y(k+1:k+Nc,:), ms_flags, freq_band_top)              

common;

for i = 1:freq_band_top
    if(ms_flags) == MS_Coding
        
        Y(i,LEFT) = Y(i,LEFT)/2;
        Y(i,RIGHT) = Y(i,RIGHT)/2;
    end
end




end