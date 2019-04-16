#!/bin/bash


fsurfer=`jq -r '.freesurfer' config.json`

source $FREESURFER_HOME/SetUpFreeSurfer.sh

mkdir -p freesurfer/mri

mri_binarize --i $fsurfer/mri/aparc+aseg.mgz --gm --o  $fsurfer/gm_mask.mgz

mri_convert $fsurfer/gm_mask.mgz  freesurfer/gm_mask.nii.gz


