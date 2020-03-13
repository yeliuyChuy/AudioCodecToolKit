function [x_idx, q_bits, x_hat] = quant_iquant_stereo(x, q_stepsize)
x_idx(:,1) = round(x(:,1)/q_stepsize(:,1));
x_idx(:,2) = round(x(:,2)/q_stepsize(:,2));

max_x1_idx = max(abs(x_idx(:,1)));
max_x2_idx = max(abs(x_idx(:,2)));

if (max_x1_idx > 0)
    q_bits(:,1) = ceil(log2(max_x1_idx)+1);
    binsNum(:,1) = max_x1_idx;
    else
    q_bits(:,1) = 1;
end
if (max_x2_idx > 0)
    q_bits(:,2) = ceil(log2(max_x2_idx)+1);
    binsNum(:,2) = max_x2_idx;
    else
    q_bits(:,2) = 1;
end
    
x_hat = x_idx .* q_stepsize;


end