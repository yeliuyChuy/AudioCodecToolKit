function M_filterbank(ifile, q_mode)
%function M_filterbank(ifile, q_mode)
%
%ifile input WAV file
%qmode
%   'f' just run analysis/synthesis filterbank
%   'q' quantize the subband values
%   'e' quantize the subband values and compute their entropy
%
% MPEG Layer I 32-band Analysis/Synthesis Filterbank
%

    %get base of filename for use in outputs
    len = length(ifile);
    base = ifile(1:len-4);

    %read input audio file
    if ( ~exist(ifile, 'file') )
        fprintf('ERROR: file %s not found\n', ifile);
        return
    end
    [x, fs] = audioread(ifile);
    [nsamp, nchn] = size(x);
    if (nchn > 1)
        x = x(:,1); %select only left to make mono
    end
    %zero padd and force to integer number of 384-length blocks
    x = [x; zeros(1024,1)];
    len = length(x);
    num_blks = floor(len/384);
    x = x(1:num_blks*384);
    %initialize y
    y = zeros(length(x), 1);

    %{
    Quantization stepsize
    divide by 32 because the synthesis filterbank will multiply input values by 32,
    and so we get 2^-15 quantization stepsize in the output waveform.
    %}
    q_stepsize = (2^-15)/32;
    %max quantizer index in subband domain
    max_S_idx = zeros(num_blks, 32);
    %max quantizer bits in subband domain
    q_bits = zeros(num_blks, 32);

    % Load filterbank coefficient tables.
    C = M_table_analysis_window;
    D = M_table_synthesis_window;

    % Initialize state variables
    X = zeros(512, 1);
    V = zeros(1024, 1); 

    %create array for all quantized subband values
    %rows are quatized values (indexes) in a subband
    %columns are subbands
    S_idx_all = zeros(num_blks*12, 32);
    %%idxBuf = zeros(num_blks*12, 32);
    % Compute matrixing functions
    % Analysis
    M = zeros(32, 64);
    for i = 0:31
        for k = 0:63
            M(i+1, k+1) = cos( (2*i + 1)*(k - 16)*pi/64 );
        end
    end
    % Synthesis
    N = zeros(64, 32);
    for i = 0:63
        for k = 0:31
            N(i+1, k+1) = cos( (16 + i)*(2*k + 1)*pi/64 );
        end
    end

    % Process input file
    blk_no = 1;
    for i = 0:384:length(x)-384
        %It then goes into a loop, where it processes blocks of 384 time samples with the analysis filterbank

        % Analysis filterbank
        % Next block of 384 = 12*32 input
        e = 1;
        S = zeros(12, 32);
        for j = 0:(12-1)
            x1 = x(i+j*32+1:i+j*32+32);
            [S(j+1,:), X] = M_analysis_filterbank(x1, C, M, X);
            %{
            produce a matrix S(12, 32) of subband time/frequency values. 
            The first index (1- 12) is the time index within a subband, 
            and the second index (1-32) is the subband index.
            %}
        end
        %
        %select operation: 
        %f = filterbank
        %q = filterbank and quantization
        %e = filterbank, quantization and calculate entropy
        %
        switch lower(q_mode)
            case 'f'
                % Just do analysis/synthesis filterbank
                S_hat = S;
            case {'q', 'e'}
                %1. Quantize the 12 samples in a band for each of the 32 bands of S(j, k) using the stepsize (2^-15)/32.
                % where j (1-12) is time index and k (1-32) is subband index 
                switch lower(q_mode)
                case 'q'
                    S_hat = zeros(12, 32);
                     for k=1:32
                    %quantize and inverse quantize this band
                    [x_idx, bitsTemp, ~] = quant_iquant(S(:,k), q_stepsize);%quantize the subband time/frequency values.
                    S_hat(:,k) = x_idx*q_stepsize;
                    q_bits(blk_no,k)= bitsTemp;% contains the number of bits needed for each quantizer for each block and each band.
                     end
                case 'e'
                    %subEntropy = 0;
                    S_hat = zeros(12, 32);
                    for k=1:32
                    [x_idx, bitsTemp, ~] = quant_iquant(S(:,k), q_stepsize);%quantize the subband time/frequency values.
                    S_hat(:,k) = x_idx*q_stepsize;             
                    S_idx_all((blk_no - 1)*12+1:(blk_no - 1)*12+12,k) = S_hat(:,k);
                    end    
                end                    
            otherwise               
                fprintf('ERROR: unknown q_mode: %s\n', q_mode);
        end
        
        % After quantization, the subband synthesis filterbank processes S_hat
        for j = 0:(12-1)
            [y1, V] = M_synthesis_filterbank(S_hat(j+1,:), D, N, V);
            y(i+j*32+1:i+j*32+32) = y1;
        end
        %increment block counter
        blk_no = blk_no +1;
    end

        allAvgBits = mean(mean(q_bits));%overall average number of bits,
        subAvgBits = mean(q_bits);% the average number of bits per subband
        
    %write output audio file
    if (nchn > 1)
        audiowrite([base, '_dynamic_tf.wav'], [y(:),y(:)], fs);
    else
        audiowrite([base, '_dynamic_tf.wav'], y, fs);
    end

    %print average number of bits needed for quantizers
    %plot the average number of bits needed for each subband 
    switch (q_mode)
        case'f'
        case'q'
            fprintf('Dynamic bit allocation of trilogy.wav in time and frequency requires %6.2f bits\n', allAvgBits);
            subplot(2,1,2)
            plot(subAvgBits);
            ylabel('Bits Required');
            xlabel('Subband');
            grid on;
    
            figure(2);
            plot(y);
            title('Output Signal');
            ylabel('Amplitude');
            xlabel('Time');
        case'e'
            avgEntropy = 0;
            for k = 1:32
                entropyTemp = entropy(S_idx_all(:,k));
                avgEntropy = avgEntropy + entropyTemp;
                
                fprintf('Entropy for quantized values per subband:%6.2f \n',entropyTemp);
            end
            avgEntropy = avgEntropy/32;
            fprintf('Average Entropy is %6.2f \n',avgEntropy);
            
            
    end
    nsx = 1:nsamp;
    nsy = nsx+512+1-32; %compensate for filterbank delay
    figure(1);
    subplot(2,1,1)
    plot(nsx, x(nsx), 'b', nsx, y(nsy), 'r');
    legend('Original', 'Decoded');
    ylabel('Sample value');
    xlabel('Sample number');
    print([base, '_dynamic_tf'], '-djpeg');
    fprintf('SNR: %5.1f dB\n', snr(x(nsx), x(nsx) - y(nsy)));
end
