%common parameters

N = 2048;   %long window length
N2 = N/2;   %coder block length, half window length
N4 = N/4;   %quarter long window
NShort = 8; %number of short windows
NS = N/NShort; %short window length
NS2= NS/2;  %short block length, half short window length
NS4= NS/4;  %quarter short window

Nbins = N2;

W_LONG  = 1;
W_START = 2;
W_SHORT = 3;
W_STOP  = 4;

fb_per_cb = 3; %freq_bands per critical band
freq_max = 18000; %highest frequency to code

WIN_HP_THR = 10; %threshold for window resolution switching

MSpow_thr_dB = 10; %M/S matrixing threshold

TMN = 15;   %tones masking noise
NMT = 3;    %noise masking tones
SSMR = 20;  %SMR for short blocks

p0_level_dB = -96;
