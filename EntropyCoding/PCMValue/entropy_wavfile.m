%that measures the entropy (h) of the sequence of values x in a PCM WAV file. 
%In addition, it plots the PDF of the sequence x.
function entropy_wavfile(ifile)

    [x, fs] = audioread(ifile);
    [nsamp, nchan] = size(x);

    if (nchan > 1) 
    x = x(:,1); %Force to mono;
    end
    q_stepsize = 2^(-15);
    
    
     %quantize
    [x_idx, q_bits, ~] = quant_iquant(x, q_stepsize);
    
     %calculate entropy of set of quantized values
    [h, p] = entropy(x_idx);
    
    fprintf('Enropy is %6.2f bits\n', h);
    plot(p)
    title('PDF of PCM Values');
    xlabel('Quantizer Index Value');
    ylabel('Probability');
    grid on;

end