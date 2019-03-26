# CSV

Code for paper - D.Temel and G. AlRegib, “CSV: Image Quality Assessment Based on Color, Structure, and Visual System”, the Signal Processing: Image Communication Journal, vol.48, pp.92-103, October 2016

<p align="center">
  <img src=/Images/graphical_abstract.png/>
</p> 

### Paper
ArXiv: https://arxiv.org/abs/1810.06464

ScienceDirect: https://www.sciencedirect.com/science/article/pii/S0923596516301151  

This is a brief explanation and demonstration of the proposed image quality assessment algorithm algorithm CSV. Given an original and a distorted image, CSV outputs a score that approximates the perceptual quality of the distorted image.


### Citation
If you find our paper and repository useful, please consider citing our paper:  
```
@article{TEMEL201692,
title = "CSV: Image quality assessment based on color, structure, and visual system",
journal = "Signal Processing: Image Communication",
volume = "48",
pages = "92 - 103",
year = "2016",
issn = "0923-5965",
doi = "https://doi.org/10.1016/j.image.2016.08.008",
url = "http://www.sciencedirect.com/science/article/pii/S0923596516301151",
author = "Dogancan Temel and Ghassan AlRegib",
keywords = "Full-reference image quality assessment, Color difference equation, Color name, Retinal ganglion cell, Suppression mechanism, Color perception",
}

```
### Code
csv.m takes reference and distorted images as input and outputs quality score.

To be able to use the FastEMD package required for the fast computation of color name distance map, run compile_FastEMD.m. For more information, refer to the ReadMe file within the FastEMD directory. 




### Abstract 
This paper presents a full-reference image quality estimator based on color, structure, and visual system characteristics denoted as CSV. In contrast to the majority of existing methods, we quantify perceptual color degradations rather than absolute pixel-wise changes. We use the CIEDE2000 color difference formulation to quantify low-level color degradations and the Earth Mover’s Distance between color name descriptors to measure significant color degradations. In addition to the perceptual color difference, CSV also contains structural and perceptual differences. Structural feature maps are obtained by mean subtraction and divisive normalization, and perceptual feature maps are obtained from contrast sensitivity formulations of retinal ganglion cells. The proposed quality estimator CSV is tested on the LIVE, the Multiply Distorted LIVE, and the TID 2013 databases, and it is always among the top two performing quality estimators in terms of at least ranking, monotonic behavior or linearity. 

### Keywords
Full-reference image quality assessment, color difference equation, color name, retinal ganglion cell, suppression mechanism, color perception.

### Visualization of Distortion Maps
Image quality assessment algorithm CSV is based on color, structure, and visual system blocks. Color block includes CIEDE 2000 COLOR difference and color name distance. We obtain four separate distortion maps from these blocks as shown below. In these maps, high values correspond to significant degradations and low values indicate minor level degradations.


<p align="center">
  <img src=/Images/maps.png/>
</p> 

### Contact:

Ghassan AlRegib:  alregib@gatech.edu, https://ghassanalregib.com/, 

Dogancan Temel: dcantemel@gmail.com, http://cantemel.com/


