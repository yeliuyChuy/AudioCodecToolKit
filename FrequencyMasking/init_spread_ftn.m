function sf_pow_band = init_spread_ftn(z_max)

common;

dz = -z_max:1/fb_per_cb:z_max;
%then using Schroeder spreading function
O_spread_ftn_db = 15.81 + 7.5*(dz+0.474) - 17.5*((1+(dz+0.474).^2).^(1/2)); 
S_spread_ftn_db = 2*(15.81 + 7.5*(dz+0.474) - 17.5*((1+(dz+0.474).^2).^(1/2))); %% Sharpend

figure(2);
plot(dz,O_spread_ftn_db,dz,S_spread_ftn_db);grid;
xlabel('Bark');
ylabel('dB');

sf_pow_band = 10.^(S_spread_ftn_db/10); %Convert the spreading function in dB to power:
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%normarlize it%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
s_sf_pow_band = (sf_pow_band - min(sf_pow_band(:)))/(max(sf_pow_band(:)) - min(sf_pow_band(:)));
%ratio = 1/sum(s_sf_pow_band);
%s_sf_pow_band = s_sf_pow_band*ratio;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sf_pow_band = s_sf_pow_band;


end  