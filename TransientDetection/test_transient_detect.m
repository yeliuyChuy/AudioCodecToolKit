function test_transient_detect(ifile, report_file)

    %common coder parameters
    common;
    
    %initialize windows
    windows = init_windows(0);

    show_plots = 1;
    
    %read input file
    if ( ~exist(ifile, 'file') )
        fprintf('File %s not found\n', ifile);
        return
    end
    [x, samp_freq] = audioread(ifile);
    [num_samp, ~] = size(x);
    fprintf('Sampling rate is %d\n', samp_freq);
    if ( ~(samp_freq == 44100 || samp_freq == 48000) )
        fprintf('Sampling rate must be 44100 or 48000\n');
        return
    end
    
    %first window is LONG
    win_seq = [W_LONG, 0, 0];
    
    %report all window length switches
    fid = fopen(report_file, 'w');
    
    n1 = 0;
    while(n1+4*N2 <= num_samp)
        %block length is N2
        %block 1 and 2 are current MDCT window
        ns0 = n1+1:n1+2*N2;
        x0 = x(ns0, :);
        %block 3 and 4 are the region of possible short MDCT windows
        %just examine block 3 and 4
        ns1 = n1+2*N2+1:n1+4*N2;
        x1 = x(ns1, :);
        
        %detect transients in blocks 3 and 4
        %adjusts window sequence for next blocks
        [win_seq, onset_idx] = mc_transient_detect(x1, win_seq);
        
        if (win_seq(3) == W_SHORT)
            %write to report file
            fprintf(fid, ...
                'Short windows at samples %8d - %8d, window index %d\n',...
                n1+1, n1+N, onset_idx); 
        end
        %plot
        if (show_plots)
            subplot(1,1,1);
            plot(1:2*N, [x0;x1], 'b'); 
            hold on
            m = 0;
            for i=1:3
                plot_windows(windows, N, m, 0.9, win_seq(i)); 
                m=m+N2;
            end
            hold off
            grid
            title(['Waveform for block at ', num2str(n1)])
            ylabel('Amplitude')
            xlabel('Sample')
            v = axis();
            axis([v(1), v(2), -1, 1]);
            if (win_seq(3) == W_SHORT)
                fprintf('Onset window index is %d\n', onset_idx);
            end
            prompt = 'CR for more plots, else enter 0: ';
            v = input(prompt);
            if (v == 0)
                show_plots = 0;
            end
        end
        
        %advance by block length
        n1 = n1+N2;
        for i=1:2
            win_seq(i) = win_seq(i+1);
        end
    end
    
    fclose(fid);
end