#!/bin/bash
#
#
#
# Written Ben Carter April 23, 2018
# This script requires an a priori mask (functional, spherical or otherwise), created via maskMaker.sh


#VARIABLES
START=$(pwd)    #starting directory
PROJECT=/fslhome/ben88/compute/Reading   #home directory
SUBJ_DIR=$PROJECT/Compute_data/SubjData #directory with individual subject data
GROUP_DIR=$PROJECT/results/Group_Analysis2/predictability3  #directory with group results
WORK_DIR=$GROUP_DIR #working directory or where you want your output files to be created.
OUTPUT=$WORK_DIR/roiStats   #statistics data
MASK=$WORK_DIR/functionalROIMask+tlrc #mask used to create statistics
DECON=afni_data/predictability3/predictability_deconv_blur5_ANTS_resampled+tlrc[5]  #path and prefix for participant's template aligned deconvolution file with subbrick

#go to the working directory
cd ${WORK_DIR}

#make the stats document
#touch ${OUTPUT}.txt

for i in $(ls $SUBJ_DIR); do
    cd ${SUBJ_DIR}/${i}/afni_data/predictability3

    stat="3dROIstats -nzmean -nzminmax -nzsigma -1DRformat -mask ${MASK} ${SUBJ_DIR}/${i}/${DECON}"
    ${stat} >> ${OUTPUT}.txt

done

cd ${WORK_DIR}
cd $START
