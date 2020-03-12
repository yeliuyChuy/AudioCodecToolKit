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

2.Aliasing: Coarse quanitzation can cause “perfect reconstruction” to fail

3.“Birdies”: Coarse quantization due to insufficient bits WRT masking threshold that causes harmonics to be coded as zero (or not) in adjacent blocks

4. Multichannel artifacts
– Shiftinstereoorfront/backsoundimage
– Unmaskingofnoiseinonechannelduetoimproperperceptualmodel

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
