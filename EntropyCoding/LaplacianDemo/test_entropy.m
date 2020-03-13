%measures the entropy (h) of sequence x. 
%In addition, it returns an estimate of the PDF of the sequence.
function test_entropy()
    N = 10*1024;
    q_stepsize=2^(-8);

    %generate Laplacian random variables
    x = round(randl(32*1024, 1)*10);
    histogram(x);
    %plot
    figure(1)
    title('Laplace Distribution');
    xlabel('Value');
    ylabel('Number of Occurances');
    print('histo', '-djpeg');

    %quantize
    [x_idx, q_bits, ~] = quant_iquant(x, q_stepsize);
    fprintf('Values need a %d bit quantizer\n', q_bits);

    %calculate entropy of set of quantized values
    [h, p] = entropy(x_idx);
    fprintf('Maximum absolute value of x (in bits) is %6.2f\n', ...
        log2(max(abs(x_idx)))+1 );
    fprintf('Enropy of this quantizer distribution is %6.2f bits\n', h);
    figure(2)
    plot(p)
    title('Laplace Distribution');
    xlabel('Value');
    ylabel('Probability');
return