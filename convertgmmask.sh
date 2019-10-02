#!/bin/bash


fsurfer=`jq -r '.freesurfer' config.json`

#I don't think we need to do this 
#source $FREESURFER_HOME/SetUpFreeSurfer.sh

mkdir -p freesurfer

mri_binarize --i $fsurfer/mri/aparc+aseg.mgz --gm --o gm_mask.mgz
mri_convert gm_mask.mgz gm_mask.nii.gz

