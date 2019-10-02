#!/bin/bash
echo "converting aparc+aseg.mgz to gm_mask.nii.gz"
fsurfer=`jq -r '.freesurfer' config.json`
mri_binarize --i $fsurfer/mri/aparc+aseg.mgz --gm --o gm_mask.mgz
mri_convert gm_mask.mgz gm_mask.nii.gz

