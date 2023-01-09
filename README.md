# A morphable model of the lumbar spine

This repository contains the data for a morphable model of the lumbar spine. A statstical shape model was created from the lumbar vertebrae (L2-L5) of 87 patients. Partial least squares regression was used to generate statistical shape models that can be morphed according to:
- Disc herniation status (yes/no)
- Spondylolisthesis status (yes/no)
- Sex 
- Age
- Mean facet angle (mean across L2-L5)
- Mean superior facets area 
- Mean inferior facets area
- Mean vertebral body depth
- Mean vertebral body height
- Mean vertebral body width
- Mean vertebral body wedge angle
- Mean superior endplate area
- Mean inferior endplate area
- Mean spinous process length
- Mean spinous process height
- Mean spinal canal depth 
- Mean spinal canal width
- Mean intervertebral disc height
- Mean intervertebral wedge angle

The morphable model for age: 

![Morphable Age Model](/images/ApproxAge.gif)

The morphable model for mean facet angle:

![Morphable Age Model](/images/meanFacetAngle.gif)

## Usage

Code is included to produce instances of the model for a given value of a parameter of interest and to produce animations of the morphable models that are viewable in [Paraview](https://www.paraview.org/). Examples are given for usage in both Matlab and Python.

## Citation
This data is associated with the following manuscript

Clouthier AL, Wenghofer J, Wai EK, Graham RB. Morphable models of the lumbar spine to vary geometry based on pathology, demographics, and anatomical measurements. Journal of Biomechanics. 2023; 146: 111421. https://doi.org/10.1016/j.jbiomech.2022.111421
