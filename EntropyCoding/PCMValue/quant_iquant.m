function [x_idx, q_bits, x_hat] = quant_iquant(x, q_stepsize)
x_idx = round(x/q_stepsize);

max_x_idx = max(abs(x_idx));

if (max_x_idx > 0)
    q_bits = ceil(log2(max_x_idx)+1);
    binsNum = max_x_idx;
    else
    q_bits = 1;
end
    
x_hat = x_idx * q_stepsize;

q_snr = snr(x, x-x_hat);

pks = max(findpeaks(x));

end