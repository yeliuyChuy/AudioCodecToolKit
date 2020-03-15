# AudioCodecToolKit

Summary of course content from the class Audio Codec offered at NYU Music Technology major. Really appreciate Dr. Quackenbush for giving us great help in learning
## Table of Contents

- [1.Perceptual Audio Coding Introduction](#PerceptualAudioCodingIntroduction)
- [2.Sampling & Quantization](#Sampling&Quantization)
- [3.Entropy Coding](#EntropyCoding)
- [4.Filterbank and Transformation](#FilterbankAndTransformation)
- [5.Entropy Coding](#EntropyCoding)

## PerceptualAudioCodingIntroduction

**What is Codec?**

The process of sound propagation from sound source to ear could be described as: Signal soundwave(analog)->A/D conversion->Digital encoding->Digital decoding->D/A conversion->Signal soundwave(analog); And the codec consists of encoder&decoder.

**Perceptual Coder methods**

1. Redundancy removal:  Model signal statistics

2. Irrelevancyremoval:  Model signal perception

3. Entropycoding:  Model probability distribution of quantized elements

**Distortions in Perceptual Coders and its reason:**

1. Pre-echo: Failure of temporal masking

2. Aliasing: Bad A/D LPF or Bad Analysis/Synthesis Filterbank

3. “Birdies”: Intermittent harmonics due to bad coding

4. Multichannel artifacts: Shift in stereo or front/back sound image, or Un masking of noise in one channel due to improper perceptual model

**Some MPEG Audio Coders standard:**

| Name      | #Channel    | Transfer Rate    | Rate Per Channel    |
| ---------- | :-----------:  | :-----------: | :-----------: |
| 1993 MPEG-1 LayerIII(MP3)    | 2     | 160 kb/s     | 80 kb/s/chn     |
| 1997 MPEG-2 AdvancedAudioCoding(AAC)     | 2     | 128 kb/s     | 64 kb/s/chn     |
| 2003 MPEG-4 HighEfficiencyAAC(HE-AAC)     | 2     | 48 kb/s     | 24 kb/s/chn     |
| 2006 MPEG-D MPEGSurround(MPS)     | 5.1     | 64 kb/s     | 13 kb/s/chn     |
| 2011 MPEG-D UnifiedSpeechandAudioCoding(USAC)     | 2     | 20 kb/s     | 10 kb/s/chn     |
| 2016 MPEG-H 3DAudio     | 24     | 768 kb/s     | 32 kb/s/chn     |

## Sampling&Quantization

**(Analog Signal)->LPF->A/D Conversion->(Digital Signal)>D/A Conversion->LPF**

1. Using LPF to bandlimit signal for eliminating aliasing.

2. Sample amplitude of analog signal at uniform intervals( Time (Fs samples per second) and Amplitude (N bits per sample))

3. The LPF after DA is for eliminating unwanted spectrum images.

**Aliasing(Nyquist criterion)**

x(t) can be completely represented by the sequence x[n] = x(nT) where (1/T) = Fs ≥ 2*Bandwidth

**Stationary**

A signal is stationary if its statistics (e.g. time envelope, spectral content) don’t change over time. Audio coding assumes and exploits signal short-time stationarity.

## EntropyCoding

**1. Estimating quantizer bin probability -> 2. Calculating Entropy -> 3. Calculating bit rate**

**1. Quantization and Estimating quantizer bin probability**
1. Quantization: A coarse amplitude representation of a signal

2. Coding loss is: 100*[(2^R - N)/2^R]%, where N is number of quantizer bins, R is the word length of the index.(i.e. 2^16 = 0.0015%)

**2. Calculating Entropy**

“Perfect” codeword length is measured by Entropy, which is the theoretical lower bound of the average number of bits that are needed to represent the set of quantized values: 

![](https://github.com/yeliuyChuy/AudioCodecToolKit/blob/master/_ReadmePics/WX20200312-174248%402x.png)

We want dynamic bit allocation in time and frequency, so divide short-time frequency into segments and design Entropy coder for each frequency segment...

**3. Calculating bit rate**

Compute bit rate per spectral region for entire signal, then sum over all spectral regions and divide by duration (in seconds) of signal.

## Masking

**1. Temporal masking** (Pre- and Post masking)
The perceptual coder assumes that the signal is “stationary” in window duration; However, when the coder encounters a transient signal, e.g. positioned at the halfway point of the window, there is a risk that the quantization noise prior to the signal transient, or onset, will be audible due to a failure of backward masking(Solution: Transient detection and force the coder to switch to “short blocks”)

Within current or neighboring coding blocks, signal event at a current time can mask events that occur before or after, which has a large impact on filterbank time/frequency resolution

![](https://github.com/yeliuyChuy/AudioCodecToolKit/blob/master/_ReadmePics/TemporalMasking.png)

**2. Frequency masking**
Within current coding block, signal power at one frequency masks coding noise at a near-by range of frequencies, which can deliver very large coding gains

![](https://github.com/yeliuyChuy/AudioCodecToolKit/blob/master/_ReadmePics/FreqMasking.png)

1. Critical Band: The equivalent rectangular bandwidth (ERB) of a cochlear filter. The Simultaneous Masking is based on the existence of critical bands. The hearing works much like a non-uniform filterbank, and the critical bands can be said to approximate the characteristics of those filters. Critical bands does not really have specific 'on' and 'off' frequencies, but rather width as a function of frequency - critical bandwidths.

2. Auditory Filters: Harvey Fletcher (Bell Labs, 1940) suggested that the auditory system behaves like a bank of overlapping bandpass filters, which he termed “auditory filters”

3. The Bark Scale: Bark scale is approximated as equal-bandwidth up to 700Hz and 1/3 octave above that, and 1 Bark is 1 critical bandwidth. The auditory system can be modeled as a filterbank, consisting of 25 overlapping bandpass filters, from 0 to 20 KHz: 

Z_bark = 13*arctan(0.76* f /1000)+3.5*arctan((f /7500)^2)
 
**Psychoacoustic Model**: Used to estimate Masking Threshold

1. Compute short-time power spectrum (FFT)

2. Map power onto Bark scale

3. Spread bark power spectrum using masking curve

4. Estimate “tonality” in each block or each band in block

5. Drop spread power spectrum by appropriate masking level: 20dB if tonal, 5 dB if not tonal

6. Map back to Hz scale: Spread power in one Bark interval over associated FFT bins
 
## FilterbankAndTransformation

Transforms are just filterbanks by another name:

| Filterbank      | Transforms    | 
| ---------- | :-----------:  | 
| IR length of 16 x number of bands  | IR length of 1 or 2 x number of bands   | 
| Very little adjacent-band leakage   | Considerable adjacent-band leakage     |

**Critical Sampling**

A filterbank is “Critically Sampled” if its data rate into the filterbank is the same as its data rate out of the filterbank. For example, in a 2-band/M-band split: analysis filter decimates by factor of 2/M and synthesis filter interpolates by factor of 2/M; Another example: A DFT with no overlap is critically sampled because N real values in and N complex values out (but only N/2 unique complex values). And a DFT with 50% overlap only has N/2 “new” real values in and N/2 complex values out, in which the information rate grows by factor of 2.

1. Decimation by N(Downsampling in the analysis bank): For low pass filter, throw away N-1 samples, keep N-th sample and the new required rate = Fs/N for Critical Sampling:

Original signal -> Filtering(HP/LP) -> Downsample by factor 2(i.e. 8k to 4k) -> The spectrum will be aliased (mirrored) to the lower frequencies.

2. Interpolation(Upsampling in the synthesis bank): Insert N-1 ”zero-valued” samples between every subband sample:

Signal from analysis filter -> Interpolation(1.Add zeros between the sample values in the signal; 2. Multiply the signal by 2 in order to keep its level unchanged ) -> The spectrum will be aliased (mirrored) to the higher frequencies -> HP filtering

3. Quantization: Dynamic allocation of bits in time and frequency can give increase in compression; Group FFT bins and applying different quantizers (i.e. quantizer stepsizes) to each group. SNR = 20log10(Vm/Vn), where Vm is the max abs value of FFT coefs in group, Vn is the Maximum noise = stepsize/2. (<- used to determine stepsize).

**MPEG-1 Filter Bank**

| Term      | Value    | 
| ---------- | :-----------:  | 
| Input block length    | 384 samples (8 ms)    | 
| # of banks     | 32     |
| Each of 32 bands contains    | 12 time samples     |

**Adaptive-resolution filterbank**: 
  
Adapt time resolution of MDCT by switching between long(good frequency response) and short(poor frequency response) transform lengths

1. High-time-resolution mode: Sufficient time resolution to control backward temporal masking (“pre-echo”)

2. High-frequency-resolution mode: Sufficient frequency resolution control frequency masking at low frequencies
 
**DFT**
 
1. Redundancy Removal: DFT “basis functions” are sine waves, which is a good match for Redundancy Removal.
 
2. Time/Frequency resolution tradeoff: Can’t have high resolution in both time and frequency. (High time resolution => short transform length; High frequency resolution => long transform length)
 
3. Windowing: Windowing yields a more accurate short-time spectrum(Lower “leakage”)
 
![](https://github.com/yeliuyChuy/AudioCodecToolKit/blob/master/_ReadmePics/DFT.png)
 
 **DCT**
 
DFT uses a set of harmonically-related complex exponential functions, while the DCT uses only (real-valued) cosine functions. A signal's DCT representation tends to have more of its energy concentrated in a small number of coefficients when compared to other transforms like the DFT. This is desirable for a compression algorithm; if you can approximately represent the original (time- or spatial-domain) signal using a relatively small set of DCT coefficients, then you can reduce your data storage requirement by only storing the DCT outputs that contain significant amounts of energy. the real part of a double-length FFT is the same as the DCT except for the half-sample phase shift in the sinusoidal basis functions

 ![](https://github.com/yeliuyChuy/AudioCodecToolKit/blob/master/_ReadmePics/MDCT.png)

**MDCT Transform**

| Term      | Value    | 
| ---------- | :-----------:  | 
| Input block length    | 1024 samples (21.3 ms)    | 
| Output     | Array of 1024 frequency coefficients    |
| Overlapping    | 50%   | 
| Critically Sampled?    | Yes   | 

 Overlap-add in synthesis cancels time-domain aliasing and design entropy code for all blocks and one freq. range.
