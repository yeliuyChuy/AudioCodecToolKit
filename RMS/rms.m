
%% 1.print RMS value for each channel
function rms(ifile)
[x, fs] = audioread(ifile);%loading audio

%split left and right channels
left_chan = x(:,1);
right_chan = x(:,2);

%get RMS for both channels
rms_left_chan = sqrt(mean (left_chan .^2)); %rms = sqrt(mean([varargin{:}].^2))
rms_right_chan = sqrt(mean (right_chan .^2));
%print results
fprintf('\nRMS value is %f for left channel and %f for right channel', ...
    rms_left_chan, rms_right_chan);

%% 2.Calculate and plot the RMS using blocks

%get number of samples
num_samps = size(x ,1);

time_blk = 20; %in milliseconds
time_blk = time_blk/1000; %in seconds

%there are 5 blocks of 20 ms inside every macro block of 100ms
micro_num_blks = 5; 
%number of samples per microblock = 960 for 20ms blocks.
micro_blk_size = fs * time_blk;
%number of samples per macroblock = 4800 or a tenth of a second at cur fs.
macro_blk_size = micro_blk_size * micro_num_blks;

%get the number of blocks of 100 ms in our sound = 93.69 macro blocks
macro_num_blks = num_samps/ macro_blk_size;
%round down to get an integer = 93 macro blocks
macro_num_blks_int = floor(macro_num_blks);
%subtract integer from original number to get fractional part. (just in case)
macro_num_blks_float = macro_num_blks-macro_num_blks_int;

%get the number of 20 ms blocks
micro_num_blks = macro_num_blks_int * 5;

fprintf('\nThe length in time of our microblock is %0.2f seconds', time_blk);

left_env = zeros(micro_num_blks,1);%make zeros for storage of rms values
right_env = zeros(micro_num_blks,1);%one if for left channel, 2 for right

%make channels fit block size
left_chan = x(1:micro_num_blks*micro_blk_size, 1); % = 449721 samples
right_chan = x(1:micro_num_blks*micro_blk_size, 2);

%get new number of samples for truncated signal
num_samps = size(left_chan,1);

rms_idx = 1;

for micro_blk_idx = 1:micro_blk_size:num_samps
    
    end_idx = micro_blk_idx+micro_blk_size-1;
    
    cur_left_blk = left_chan(micro_blk_idx:end_idx,1);
    cur_right_blk = right_chan(micro_blk_idx:end_idx,1);
    
    left_env(rms_idx, 1) = sqrt(mean (cur_left_blk .^2));
    right_env(rms_idx, 1) = sqrt(mean (cur_right_blk .^2));
    
    rms_idx = rms_idx+1;
    
end

%% 
% use a loop and CR to plot one-tenth of a sec at a time (50 micro blocks)

figure(1)
subplot(2,1,1);
plot(left_env);
hold on;
plot(right_env);
title('Time Envelope');
xlabel('Micro blocks (20 ms)');
ylabel('RMS Value');
xlim ([0, micro_num_blks]);
ylim ([0, .15]);

subplot(2,1,2);
plot(x);
title('Signal');
xlabel('Sample');
ylabel('Amplitude');


%fprintf('\nfn+cntrl+C to cancel\n');
fprintf('CR to continue\n'); pause

num_blks  = 5;
xlim_idx = 0;

for i=0:num_blks:micro_num_blks
    
        figure(1)
        subplot(2,1,1);
        plot(left_env);
        hold on;
        plot(right_env);
        title('Time Envelope');
        xlabel('Micro blocks (20 ms)');
        ylabel('RMS Value');
        xlim ([i, i+num_blks]);
        ylim ([0, .15]);
        
        subplot(2,1,2);
        plot(x);
        title('Signal');
        xlabel('Sample');
        ylabel('Amplitude');
        xlim ([xlim_idx, xlim_idx + fs/10]);
        
        xlim_idx = xlim_idx+ fs/10;
        
        fprintf('\nfn+cntrl+C to cancel\n');
        fprintf('CR to continue\n'); pause
         
end

