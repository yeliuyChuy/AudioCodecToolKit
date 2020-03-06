function tandem(ifile, n, b)
%function mk_tandem(ifile, n, b)
%perform tandem coding using MPEG-4 Advanced Audio Coding (AAC)
%ifile is original WAV file
%n is number of encode/decode passes (i.e. tandems)
%b is bitrate, in kilobytes/second for each encoding

    if ~exist(ifile, 'file')
        fprintf('File %s not found\n', ifile);
        return;
    end
    ofile = sprintf('%s_tandem%02d.wav', ifile(1:end-4), n);

    N = 1024; %AAC block size
    first_samp = round(N*rand(n,1));
    first_samp(1) = 1; %force first pass first sample to 1
    
    [orig, fs] = audioread(ifile);
    [~, num_chan] = size(orig);

    y = orig;
    for i=1:n
        fprintf('Pass %2d starting at sample %d\n', i, first_samp(i));
        x = y(first_samp(i):end,:);
        %write and convert from PCM to MPEG AAC coded file
        audiowrite('tmp.m4a', x, fs, 'BitRate', b); 
        %read back and convert from MPEG AAC coded file to PCM
        y = audioread('tmp.m4a');
        %put back samples as excerpt from original
        if (first_samp(i) > 1)
            z = orig(1:first_samp(i)-1, :);
            y = [z;y];
        end
    end
    
    %write result to output file
    audiowrite(ofile, [z;y], fs);
end

