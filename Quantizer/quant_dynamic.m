function [x_idx, q_bits, x_hat] = quant_dynamic(x, q_stepsize, ifile, fs,nsamp)
%Dynamic Bit Allocation over Time
%This quantizer is used every 20 ms(20 ms is 960 samples at 48K)
%During a period of low signal amplitude, we can use fewer bits to represent the signal.

N = round(0.020 * fs); %segment x into 20 ms blocks of size N

%determine number of blocks, discarding any fractional block
num_blks = floor(nsamp/N); 
      
x = x(1:num_blks*N); %Valid sample numbers in the end
      
x_idx = zeros(num_blks*N, 1);%create the empty array
      
q_bits = zeros(num_blks, 1);
      
x_hat = zeros(num_blks*N, 1);

pks = zeros(num_blks*N, 1);
      
n = 0;
%quantizing over blocks      
for (i = 1:num_blks)
  %%get a block of signal x  
  x1 = x(n+1:n+N);

  %quantize this block
  x_idx(n+1:n+N) = round(x1/q_stepsize);%round the signal with stepsize in current block
  
  max_x_idx = max(abs(x_idx(n+1:n+N)));
  if (max_x_idx > 0)
    %since we take abs() we have to add back "sign bit"
    q_bits(n+1:n+N) = ceil(log2(max_x_idx)+1);
    binsNum = max_x_idx;
    else
    q_bits(n+1:n+N) = 1;
  end
  %q_bits(n+1:n+N) = ceil(log2(max(abs(x_idx(n+1:n+N))))+1);%get the bits number which can represent the steps in current block
  binsNum(n+1:n+N) = max(abs(x_idx(n+1:n+N)));%calculate the bins number in the current block.
  x_hat(n+1:n+N) = x_idx(n+1:n+N) * q_stepsize;%reconstruct the signal
  x(n+1:n+N) = x1;
  
  pks(n+1:n+N) = max(findpeaks(x_hat(n+1:n+N)));
  
  n = n + N;      
end
      
bitsAvg = mean(q_bits); %average bits!  
q_snr = snr(x, x-x_hat);%calculate the SNR ration
binsNum = binsNum'; %transpose the array of bins number
binsNum = binsNum * q_stepsize;
fprintf('The average number of bits over all blocks is %0.2f bits. \n ', bitsAvg);

subplot(2,1,1)
plot(x);
xlabel('Samples'),ylabel('Amplitude')
hold on

subplot(2,1,1)
plot(pks,'r')
hold off

subplot(2,1,2) %print the zoom-in graph!
plot(x);
xlim([0 0.5*(10^5)]);
xlabel('Samples'),ylabel('Amplitude')
hold on

subplot(2,1,2)
plot(pks,'red');
xlim([0 0.5*(10^5)]);
hold off
fprintf('Dynamic bit allocation of %s requires %0.2f average bits, Quantization SNR is %d dB \n',ifile,bitsAvg,q_snr);

end