function mdct_ola(ifile, q_mode)
%
%mdct analysis/synthesis with 50% overlap that
%   is multi-channel
%   has adaptive block length switching
%
%ifile in input *.wav file
%q_mode
%   't' just to MDCT analysis/synthesis
%   'q' quantize
%   'e' quantize and compute entropy 
%
%ofile is ifile_out.wav

    %coder parameters
    common;

    %read input file
    if ( ~exist(ifile, 'file') )
        fprintf('File %s not found\n', ifile);
        return
    end
    [s, fs] = audioread(ifile);
    [num_samp, num_chan] = size(s);
    fprintf('File %s is %d channels and %d sampling rate\n', ...
        ifile, num_chan, fs);
    if (fs < 44100)
        fprintf('Sampling rate must be 44100 or 48000\n');
        return
    end

    %set up for time-aligned output
    n = mod(num_samp, N2);
    %padd with 1 block before
    %padd after to fill to full block plus one more block plus
    %two more block-switching look-ahead blocks
    nla = 2*N2;
    s1 = [zeros(N2,num_chan);s;zeros(N2-n + N2 + nla, num_chan)];
    [num_samp_1, ~] = size(s1);
    num_blocks = (num_samp_1-N-nla)/N2;

    %output file
    n = length(ifile);
    base = ifile(1:n-4); %remove '.wav' extension 
    ofile = [base,'_out.wav'];

    %create windows
    windows = init_windows(0);

    %
    %quantization bands
    %and quantization parameters
    %
    top_bin = mk_octave_bands(N2);
    num_bands = length(top_bin);
    q_bits = zeros(num_blocks+1, num_bands, num_chan);
    X_idx = zeros(num_blocks+1, N2, num_chan);
    entropyBuf1 = zeros(1,num_bands);
    entropyBuf2 = zeros(1,num_bands);
    X1_idx = zeros(num_blocks+1, N2);
    X2_idx = zeros(num_blocks+1, N2);
    
    
    %pre-allocate arrays
    win_seq = [W_LONG, 0, 0];
    s_out = zeros(num_samp, num_chan); %decoded signal
    yprev = zeros(N2,num_chan); %prev block for overlap-add
    %initialize other variables
    n1 = 0;
    n2 = 0;
    win_seq(1) = W_LONG;
    fprintf('%d blocks\n', num_blocks);
    for bno = 0:num_blocks
        %fprintf('block %d window %d\n', bno, win_seq(1));
        %if (mod(bno, 50)==0); fprintf('block %d\n', bno); end
        
        %extract current block from signal
        x1 = s1(n1+1:n1+N, :);

        %window and compute mdct and FFT
        [X, ~] = mc_mdct_fft2(x1, windows, win_seq(1));
                
        %
        %quantize X and code
        %
        switch lower(q_mode)
        case 't'
            %just do MDCT analysis/synthesis
            X_hat = X;
        case {'q', 'e'}
            %quantize if 'q' or 'e'
            %calculate entropy of 'e'
                %==============================================================stereo
               if(num_chan>1)
                j = 1;
                for i = 1:10
                    if (i~=1)
                    j = 2^(i-1) + 1;
                    end
                        q_stepsize = max(abs(X(j:top_bin(i),:)))/10;
                        %q_stepsize = max(abs(X(j:top_bin(i),:)))*2/3; %2 or 3 on the impairment scale.
                        %q_stepsize = max(abs(X(j:top_bin(i),:)))*1/5; %4 or 5 on the impairment scale.  
                        [x_idx, bitsTemp, x_hat] = quant_iquant_stereo(X(j:top_bin(i),:), q_stepsize); 
                        q_bits(bno+1,i,:) = bitsTemp;
                        X_idx(bno+1,j:top_bin(i),:) = x_idx;  
                        X_hat(j:top_bin(i),:) = x_hat;
                end
                
               elseif (num_chan == 1)                  
                j = 1;
                for i = 1:num_blocks
                    if (i~=1)
                    j = 2^(i-1) + 1;
                    end
                        q_stepsize = max(abs(X(j:top_bin(i),:)))/10;
                        [x_idx, bitsTemp, x_hat] = quant_iquant_mono(X(j:top_bin(i)), q_stepsize); 
                        q_bits(bno+1,i) = bitsTemp;
                        X_idx(bno+1,j:top_bin(i)) = x_idx;  
                        X_hat(j:top_bin(i),:) = x_hat;        
                end
               end
               
        otherwise
            fprintf('ERROR: unknown mode %s\n', q_mode);
            return;
        end

        %apply inverse mdct, window and overlap-add
        [y, yprev] = mc_imdct_fft2(X_hat, windows, win_seq(1), yprev);

        if bno > 0
            %save output so it is time-aligned with input
            s_out(n2+1:n2+N2,:) = y;
            %advance output sample counter
            n2 = n2+N2; 
        end   

        %advance input sample counter
        n1 = n1+N2;
    end
    
    if(num_chan>1)
    X1_idx = X_idx(:,:,1);
    X2_idx = X_idx(:,:,2);
    q1_bits = q_bits(:,:,1);
    q2_bits = q_bits(:,:,2);
        
    end

    %clip off last fraction of a block in coded output
    s_out = s_out(1:num_samp,:);

    %calcualate SNR
    nsx = 1:num_samp;
    nsy = nsx  ; %compensate! 
    fprintf('SNR is : %5.1f dB\n', snr(s(nsx), s(nsx) - s_out(nsy)));

    %write out coded result
    audiowrite(ofile, s_out, fs);

    if(q_mode == 'q' || q_mode == 'e')
        %results of quantization
        
        if (num_chan > 1)
            if (q_mode == 'e')
                    j = 1;
                    for i = 1:num_bands
                        if (i~=1)
                        j = 2^(i-1) + 1;
                        end
                    entropyBuf1(i) = entropy(X1_idx(:,j:top_bin(i)));
                    entropyBuf2(i)= entropy(X2_idx(:,j:top_bin(i)));
                    end
      
            avg_entropy1 = mean(entropyBuf1);
            avg_entropy2 = mean(entropyBuf2);
            fprintf('Channel 1: %6.2f bits per sample with entropy coding\n',avg_entropy1); 
            fprintf('Channel 2: %6.2f bits per sample with entropy coding\n',avg_entropy2);
            figure(3);
            subplot(2,1,1)
            plot(entropyBuf1);
            xlabel('Bands');
            ylabel('Bits');
            title('Entropy By Bands:Channel1.');
            grid on;
            
            subplot(2,1,2)
            plot(entropyBuf2);
            xlabel('Bands');
            ylabel('Bits');
            title('Entropy By Bands:Channel2.');
            grid on;
            end
            %========================================================
            avgBit1 = mean(q1_bits);
            avgBit2 = mean(q2_bits);        
        fprintf('%6.2f bits per sample with uniform quantizer\n',avgBit1);    
        
        figure(2);
        subplot(2,1,1)
        plot(avgBit1,'x');
        xlabel('Bands');
        ylabel('Bits');
        title('Bit Allocation:Channel1.');
        grid on;
        
        subplot(2,1,2)
        plot(avgBit2,'x');
        xlabel('Bands');
        ylabel('Bits');
        title('Bit Allocation:Channel2.');
        grid on;
        end
        
        if (num_chan ==1) %===========================================================stereo
            if (q_mode == 'e')
                    j = 1;
                    for i = 1:num_bands
                        if (i~=1)
                        j = 2^(i-1) + 1;
                        end
                    [h(i),p1] = entropy(X_idx(:,j:top_bin(i)));
                    end
      
            %avg_entropy1 = mean(h1);
            %avg_entropy2 = mean(h2);
            figure(3);
            subplot(2,1,1)
            plot(h);
            xlabel('Bands');
            ylabel('Bits');
            title('Entropy By Bands:Channel1.');
            grid on;
            end
            
            avgBit = mean(q_bits);
        fprintf('%6.2f bits per sample with uniform quantizer\n',avgBit); 
        figure(2);
        plot(avgBit,'x');
        xlabel('Bands');
        ylabel('Bits');
        title('Bit Allocation:Channel1.');
        grid on;
        end
        if (q_mode == 'e')
            %entropy code the quantiziation result in each band
            %%%%%YOUR CODE HERE%%%%%
                        %channel1 = X_idx(X1_idx);
                        %channel2 = X_idx(:,:,2);
     
        end
    end
    
    if (1)
        figure(1)
        %plot original and reconstructed waveform
        ns = 1:num_samp;
        for i=1:num_chan
            subplot(num_chan, 1, i);
            plot(ns, s, 'b', ns, s_out, 'r'); grid
            legend('Original', 'Reconstructed');
            title(['Analysis/Synthesis, Channel ', num2str(i)])
            ylabel('Amplitude')
            xlabel('Sample')
            if (i==1); hold on; end
        end
        print([base, '_out'], '-djpeg');
        hold off
    end
end
    