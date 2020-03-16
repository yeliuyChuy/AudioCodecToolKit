function [ms_flags, X, mdct_qs_bands_hat] = ms_encode(X, mdct_qs_bands_hat, Xs_pow_bands, freq_band_top)
% [ms_flags, X(k+1:k+Nc,:), mdct_qs_bands_hat] = ms_encode(X(k+1:k+Nc,:), mdct_qs_bands_hat,  Xs_pow_bands, freq_band_top);
    common;           

    for i = 1:length(freq_band_top)
     chan_pow(i, LEFT) = Xs_pow_bands(i, LEFT);
     chan_pow(i, RIGHT) = Xs_pow_bands(i, RIGHT);
    
     sum_dB = 10*log10(chan_pow(i, LEFT) + chan_pow(i, RIGHT));
     diff_dB = 10*log10(chan_pow(i, LEFT) - chan_pow(i, RIGHT));

    if ( (sum_dB - diff_dB) > 3 )
          %setup for Mid coding
          ms_flags(i) = MS_Coding;
          %more operations to implement
          % M = L+R   (sum)
          %M = mdct_qs_bands_hat(i, LEFT) + mdct_qs_bands_hat(i, RIGHT);
             M = X(i, LEFT) + X(i, RIGHT);%sum
             M_mdct = mdct_qs_bands_hat(i, LEFT) + mdct_qs_bands_hat(i, RIGHT);
          % S = L-R   (difference)
          %S = mdct_qs_bands_hat(i, LEFT) - mdct_qs_bands_hat(i, RIGHT);
             S = X(i, LEFT) - X(i, RIGHT);%difference
             S_mdct = mdct_qs_bands_hat(i, LEFT) - mdct_qs_bands_hat(i, RIGHT);

          
          %==================Reconstruction=====================

          mdct_qs_bands_hat(i,LEFT) = M_mdct+S_mdct;
          X(i,LEFT) = M+S;
          mdct_qs_bands_hat(i,RIGHT) = M_mdct-S_mdct;
          X(i,RIGHT) = M-S;
          
     else
          %setup for Side coding
          ms_flags(i) = LR_Coding;
    end
    end
                
                
end
