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
| 1993 MPEG-1LayerIII(MP3)    | 2     | 160 kb/s     | 80 kb/s/chn     |
| 1997 MPEG-2AdvancedAudioCoding(AAC)     | 2     | 128 kb/s     | 64 kb/s/chn     |
| 2003 MPEG-4HighEfficiencyAAC(HE-AAC)     | 2     | 48 kb/s     | 24 kb/s/chn     |
| 2006 MPEG-DMPEGSurround(MPS)     | 5.1     | 64 kb/s     | 13 kb/s/chn     |
| 2011 MPEG-DUnifiedSpeechandAudioCoding(USAC)     | 2     | 20 kb/s     | 10 kb/s/chn     |
| ---------- | :-----------:  | :-----------: | :-----------: |
| 2016 MPEG-H3DAudio     | 24     | 768 kb/s     | 32 kb/s/chn     |

## Sampling&Quantization

b
b
b
b
b
b
b
b
b
b
b
b



## EntropyCoding

c
c
c
c
c

c
c
c
c
c
