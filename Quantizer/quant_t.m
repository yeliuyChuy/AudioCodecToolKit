function quant_t(ifile, q_mode)
%Performing static quantization in time domain

[x, fs] = audioread(ifile);
[nsamp, nchan] = size(x);
%due to the wav PCM representation, signal in Matlab quantized with
%a steo size 1/32768(2^-15) between [-1,1].
q_stepsize = 2^(-15);

if (nchan > 1) 
    x = x(:,1); %force to mono
end

switch lower(q_mode)
    %static
    case 'static'
      [x_idx, q_bits, x_hat] = quant_static(x, q_stepsize, ifile); 
    %dynamic
    case 'dynamic'
      [x_idx, q_bits, x_hat] = quant_dynamic(x, q_stepsize, ifile,fs,nsamp); 
      
end
audiowrite('QuantizerTest.wav', [x_hat(:), x_hat(:)], fs); 
end