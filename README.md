# AudioCodecToolKit

Summary of course content from the class Audio Codec offered at NYU Music Technology major. Really appreciate Dr. Quackenbush for giving us great help in learning
## Table of Contents

- [1.Perceptual Audio Coding Introduction](#PerceptualAudioCodingIntroduction)
- [2.Sampling & Quantization](#Sampling&Quantization)
- [3.Entropy Coding](#EntropyCoding)

## PerceptualAudioCodingIntroduction

* What is Codec?

The process of sound propagation from sound source to ear could be described as: Signal soundwave(analog)->A/D conversion->Digital encoding->Digital decoding->D/A conversion->Signal soundwave(analog); And the codec consists of encoder&decoder.

* Perceptual Coder methods

1. Redundancy removal:  Model signal statistics

2. Irrelevancyremoval:  Model signal perception

3. Entropycoding:  Model probability distribution of quantized elements

* Distortions in Perceptual Coders and its reason:

1. Pre-echo: Failure of temporal masking

2. Aliasing: Bad A/D LPF or Bad Analysis/Synthesis Filterbank

3. “Birdies”: Intermittent harmonics due to bad coding

4. Multichannel artifacts: Shift in stereo or front/back sound image, or Un masking of noise in one channel due to improper perceptual model

* Some MPEG Audio Coders standard:

1. 1982CompactDisc(CD)
2. 1993MPEG-1LayerIII(MP3)
3. 1997MPEG-2AdvancedAudioCoding(AAC)
4. 2003MPEG-4HighEfficiencyAAC(HE-AAC)
5. 2006MPEG-DMPEGSurround(MPS)
6. 2011MPEG-DUnifiedSpeechandAudioCoding(USAC) • 2016MPEG-H3DAudio


| Name      | #Channel    | Transfer Rate    | Rate Per Channel    |
| ---------- | :-----------:  | :-----------: | :-----------: |
| 第一行     | 第一列     | 第二列     | 第三列     |

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
