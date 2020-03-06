function [x_idx, q_bits, x_hat] = quant_static(x, q_stepsize, ifile)
%Quantize x with the quantizer stepsize q_stepsize. 
%Compute the number of bits needed to express all values in array x_idx.

%where
%x is signal vector to quantize
%q_stepsize is scalar quantization stepsize
%x_idx is vector of quantizer indices
%q_bits is scalar of number of bits needed to count all indices
%x_hat is reconstructed signal vector

x_idx = round(x/q_stepsize);

max_x_idx = max(abs(x_idx)); %the number of quantizer bins

if (max_x_idx > 0)
    %since we take abs() we have to add back "sign bit"
    q_bits = ceil(log2(max_x_idx)+1);
    binsNum = max_x_idx;
    else
    q_bits = 1;
end
%Inverse quantize x_idx to obtain the reconstructed signal x_hat.     
x_hat = x_idx * q_stepsize;
%Compute and print the SNR of x with respect to x_hat.
q_snr = snr(x, x-x_hat);

pks = max(findpeaks(x));

plot(pks*ones(size(x_hat)),'r')

hold on
plot(x_hat);
xlabel('Samples'),ylabel('Amplitude')

hold off
fprintf('Static bit allocation of %s requires %d bits, Quantization SNR is %d dB \n',ifile,q_bits,q_snr);
end