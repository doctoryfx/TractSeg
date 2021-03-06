# TractSeg
 
![Alt text](examples/resources/Pipeline_img_for_readme.png)

Tool for fast and accurate white matter bundle segmentation from Diffusion MRI. It can create 
bundle segmentations, segmentations of the endregions of bundles and Tract Orientation Maps (TOMs).

The tool works very well for data similar to the Human Connectome Project. For other MRI datasets 
it fails for the Commissure Anterior (CA) and the Fornix (FX) but works quite well for all
other bundles.

TractSeg is the code for the papers [TractSeg - Fast and accurate white matter tract segmentation](https://doi.org/10.1016/j.neuroimage.2018.07.070)
and [Tract orientation mapping for bundle-specific tractography](https://arxiv.org/abs/1806.05580). 
Please cite the papers if you use it. 

[![Build Status](https://travis-ci.org/MIC-DKFZ/TractSeg.svg?branch=master)](https://travis-ci.org/MIC-DKFZ/TractSeg)

## Install
TractSeg only runs on Linux and OSX. It works with Python 2 and Python 3.

#### Install Prerequisites
* [Pytorch](http://pytorch.org/) (if you do not have a GPU, installing Pytorch via conda might be faster)
* [Mrtrix 3](http://mrtrix.readthedocs.io/en/latest/installation/linux_install.html)
* [FSL](https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/FslInstallation) (if you already have a brain mask this is not needed)
* BatchGenerators: `pip install https://github.com/MIC-DKFZ/batchgenerators/archive/master.zip`

#### Install TractSeg
Latest stable version:
```
pip install https://github.com/MIC-DKFZ/TractSeg/archive/v1.4.zip
```

#### Docker
You can also directly use TractSeg via Docker (contains all prerequisites). However, it 
only supports CPU, not GPU. 
```
sudo docker run -v /absolute/path/to/my/data/directory:/data \
-t wasserth/tractseg_container:v1.4 TractSeg -i /data/my_diffusion_file.nii.gz -o /data
```
On OSX you might have to increase the Docker memory limit from the default of 2GB to something
like 7GB.
## Usage

#### Simple example:
To segment the bundles on a Diffusion Nifti image run the following command. 
You can use the example image provided in this repository under `examples`.  
```
TractSeg -i Diffusion.nii.gz    # expects Diffusion.bvals and Diffusion.bvecs to be in the same directory
```
This will create a folder `tractseg_ouput` inside of the same directory as your input file. 
This folder contains `bundle_segmentations.nii.gz` which is a 4D Nifti image (`[x,y,z,bundle]`). 
The fourth dimension contains the binary bundle segmentations.
 
NOTE: Your input image should have the same orientation as MNI space (using rigid 
registration to MNI space is a simply way to ensure this). 

#### Custom input and output path:
```
TractSeg -i my/path/my_diffusion_image.nii.gz
         -o my/output/directory
         --bvals my/other/path/my.bvals
         --bvecs yet/another/path/my.bvecs
         --output_multiple_files
```

#### Use existing peaks
```
TractSeg -i my/path/my_mrtrix_csd_peaks.nii.gz --skip_peak_extraction
```

#### Create Tract Orientation Maps (TOMs)
TOM ([Wasserthal et al., Tract orientation mapping for bundle-specific tractography](https://arxiv.org/abs/1806.05580)) only supports 20 bundles.
```
TractSeg -i Diffusion.nii.gz --output_type TOM --output_multiple_files
```

#### Segment bundle start and end regions
```
TractSeg -i Diffusion.nii.gz --output_type endings_segmentation --output_multiple_files
```

#### Bundle names
The following list shows the index of 
each extracted bundle in the output file.
```
0: AF_left         (Arcuate fascicle)
1: AF_right
2: ATR_left        (Anterior Thalamic Radiation)
3: ATR_right
4: CA              (Commissure Anterior)
5: CC_1            (Rostrum)
6: CC_2            (Genu)
7: CC_3            (Rostral body (Premotor))
8: CC_4            (Anterior midbody (Primary Motor))
9: CC_5            (Posterior midbody (Primary Somatosensory))
10: CC_6           (Isthmus)
11: CC_7           (Splenium)
12: CG_left        (Cingulum left)
13: CG_right   
14: CST_left       (Corticospinal tract)
15: CST_right 
16: MLF_left       (Middle longitudinal fascicle)
17: MLF_right
18: FPT_left       (Fronto-pontine tract)
19: FPT_right 
20: FX_left        (Fornix)
21: FX_right
22: ICP_left       (Inferior cerebellar peduncle)
23: ICP_right 
24: IFO_left       (Inferior occipito-frontal fascicle) 
25: IFO_right
26: ILF_left       (Inferior longitudinal fascicle) 
27: ILF_right 
28: MCP            (Middle cerebellar peduncle)
29: OR_left        (Optic radiation) 
30: OR_right
31: POPT_left      (Parieto‐occipital pontine)
32: POPT_right 
33: SCP_left       (Superior cerebellar peduncle)
34: SCP_right 
35: SLF_I_left     (Superior longitudinal fascicle I)
36: SLF_I_right 
37: SLF_II_left    (Superior longitudinal fascicle II)
38: SLF_II_right
39: SLF_III_left   (Superior longitudinal fascicle III)
40: SLF_III_right 
41: STR_left       (Superior Thalamic Radiation)
42: STR_right 
43: UF_left        (Uncinate fascicle) 
44: UF_right 
45: CC             (Corpus Callosum - all)
46: T_PREF_left    (Thalamo-prefrontal)
47: T_PREF_right 
48: T_PREM_left    (Thalamo-premotor)
49: T_PREM_right 
50: T_PREC_left    (Thalamo-precentral)
51: T_PREC_right 
52: T_POSTC_left   (Thalamo-postcentral)
53: T_POSTC_right 
54: T_PAR_left     (Thalamo-parietal)
55: T_PAR_right 
56: T_OCC_left     (Thalamo-occipital)
57: T_OCC_right 
58: ST_FO_left     (Striato-fronto-orbital)
59: ST_FO_right 
60: ST_PREF_left   (Striato-prefrontal)
61: ST_PREF_right 
62: ST_PREM_left   (Striato-premotor)
63: ST_PREM_right 
64: ST_PREC_left   (Striato-precentral)
65: ST_PREC_right 
66: ST_POSTC_left  (Striato-postcentral)
67: ST_POSTC_right
68: ST_PAR_left    (Striato-parietal)
69: ST_PAR_right 
70: ST_OCC_left    (Striato-occipital)
71: ST_OCC_right
```

#### Bundles supported by TOM
```
"AF_left", "AF_right", "CA", "CST_left", "CST_right", "CG_left", "CG_right",
"ICP_left", "ICP_right", "MCP", "SCP_left", "SCP_right", "ILF_left", "ILF_right",
"IFO_left", "IFO_right", "OR_left", "OR_right", "UF_left", "UF_right"
```

#### Advanced Options
Run `TractSeg --help` for more advanced options. For example you can specify your own `brain_mask`,
`bvals` and `bvecs`.

If you have multi-shell data and you do not need fast runtime use `--csd_type csd_msmt_5tt` for slightly better results.

#### Use python interface
```
import nibabel as nib
import numpy as np
from tractseg.TractSeg import run_tractseg
peaks = nib.load("examples/Diffusion_mrtrix_peaks.nii.gz").get_data()
peaks = np.nan_to_num(peaks)
segmentation = run_tractseg(peaks)
```

## FAQ
**My output segmentation does not look like any bundle at all!**

The input image must have the same "orientation" as the Human Connectome Project data (MNI space) (LEFT must be on the same side as 
LEFT of the HCP data). If the image orientation and the gradient orientation of your data is the same as in `examples/Diffusion.nii.gz`
you are fine. Otherwise you should rigidly register your image to MNI space (the brains
do not have to be perfectly aligned but must have the same LEFT/RIGHT orientation).
You can use the following FSL commands to rigidly register you image to MNI space (uses 
the FA to calculate the transformation as this is more stable):
```
calc_FA -i Diffusion.nii.gz -o FA.nii.gz --bvals Diffusion.bvals --bvecs Diffusion.bvecs \
--brain_mask nodif_brain_mask.nii.gz

flirt -ref tractseg/examples/resources/MNI_FA_template.nii.gz -in FA.nii.gz \
-out FA_MNI.nii.gz -omat FA_2_MNI.mat -dof 6 -cost mutualinfo -searchcost mutualinfo

flirt -ref tractseg/examples/resources/MNI_FA_template.nii.gz -in Diffusion.nii.gz \
-out Diffusion_MNI.nii.gz -applyxfm -init FA_2_MNI.mat -dof 6
cp Diffusion.bvals Diffusion_MNI.bvals
cp Diffusion.bvecs Diffusion_MNI.bvecs
```
Even if the input image is in MNI space the Mrtrix peaks might still be flipped. You should view
the peaks in `mrview` and make sure they have the proper orientation. Otherwise you might have to 
flip the sign along the x, y or z axis. You can use the following command to do that 
```
flip_peaks -i my_peaks.nii.gz -o my_peaks_flip_y.nii.gz -a y
``` 

**Did I install the prerequisites correctly?**

You can check if you installed Mrtrix correctly if you can run the following command on your terminal:
`dwi2response -help`

You can check if you installed FSL correctly if you can run the following command on your terminal: 
`bet -help`

TractSeg uses these commands so they have to be available.


## Train your own model
TractSeg uses a pretrained model. However, you can also train your own model on your own data.
But be aware: This is more complicated than just running with the pretrained model. The following 
guide is quite short and you might have problems following every step. Contact the author if
you need help training your own model.

1. The folder structure of your training data should be the following:
```
custom_path/HCP/subject_01/
      '-> mrtrix_peaks.nii.gz       (mrtrix CSD peaks;  shape: [x,y,z,9])
      '-> bundle_masks.nii.gz       (Reference bundle masks; shape: [x,y,z,nr_bundles])
custom_path/HCP/subject_02/
      ...
```
2. Adapt the file tractseg/config/custom/My_custom_experiment.py.
3. Create a file `~/.tractseg/config.txt`. This contains the path to your data directory, e.g.
`working_dir=custom_path`.
4. Adapt `tractseg.libs.DatasetUtils.scale_input_to_unet_shape()` to scale your input data to the 
UNet input size of `144x144`. This is not very convenient. Contact the author if you need help.
5. Adapt `tractseg.libs.ExpUtils.get_bundle_names()` with the bundles you use in your reference data.
6. Adapt `tractseg.libs.ExpUtils.get_labels_filename()` with the names of your label files.
7. Adapt `tractseg.libs.Subjects` with the list of your subject IDs.
8. Run `ExpRunner --config My_custom_experiment` 
9. `custom_path/hcp_exp/My_custom_experiment` contains the results


## Docker
To build a docker container with all dependencies run the following command in project root:
```
sudo docker build -t tractseg_container .
```