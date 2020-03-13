# AudioCodecToolKit

Summary of course content from the class Audio Codec offered at NYU Music Technology major. Really appreciate Dr. Quackenbush for giving us great help in learning
## Table of Contents

- [1.Perceptual Audio Coding Introduction](#PerceptualAudioCodingIntroduction)
- [2.Sampling & Quantization](#Sampling&Quantization)
- [3.Entropy Coding](#EntropyCoding)

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

**Quantization**

1. A coarse amplitude representation of a signal

2. Coding loss is: 100*[(2^R - N)/2^R]%, where N is number of quantizer bins, R is the word length of the index.(i.e. 2^16 = 0.0015%)

## EntropyCoding
“Perfect” codeword length is measured by Entropy: 

![](https://github.com/yeliuyChuy/AudioCodecToolKit/blob/master/_ReadmePics/WX20200312-174248%402x.png)

We want dynamic bit allocation in time and frequency, so divide short-time frequency into segments and design Entropy coder for each frequency segment...

## MPEG-1 Filter Bank

| Term      | Value    | 
| ---------- | :-----------:  | 
| Input block length    | 384 samples (8 ms)    | 
| # of banks     | 32     |
| Each of 32 bands contains    | 12 time samples     |
