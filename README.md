# DE1SoC Linux Peripheral for HEVC
Master's Degree Thesis: An Hardware Accelerator for HEVC implemented on a DE1SoC FPGA 

## Introduction
HEVC (High Efficiency Video Coding), the most recent standard for video
compression, has led to an huge increase of the encoding efficiency with the
respect to the previous standards but, on the other hand, several tasks have
became highly time demanding and power consuming.
The HEVC encoder doubled the coding efficiency without affecting the quality,
but increased exponentially the computational cost.
According to the standard, the encoder, at every cycle, selects a frame from the
input stream and subdivide it into partitions of blocks.
Forn each of those block is then performed a prediction with **Intra** or
**Inter** prediction. The first technique performs a comparison between
blocks in the same picture and, thus, remove spatial redundancy.
The second technique, instead, compares blocks of samples present in different
frames, exploiting motion compensation and reducing temporal redundancy.
This thesis proposes, therefore, a fast, dynamically reconfigurable and flexible
hardware accelerator for the SATD (Sum of Absolute Transformed Differences),
that is one of the cost functions adopted by HM HEVC reference software in both
the prediction techniques (Intra Prediction search and Fractional Motion
Estimation).

