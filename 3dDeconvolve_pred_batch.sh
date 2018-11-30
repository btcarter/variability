#!/bin/bash

#######################################
#PREPROCESSING BATCH SUBMISSION SCRIPT#
#######################################

#Written by Ben Carter 11/29/2018

#############
#ENVIRONMENT#
#############

PREFIX=variability #the prefix your are using for this analysis
HOME_DIR=/fslhome/ben88/compute/Reading
SCRIPT_DIR=${HOME_DIR}/analyses/${PREFIX}
SUBJ_DIR=${HOME_DIR}/mriData

##########
#COMMANDS#
##########

#Create logfiles directory
var=`date +"%Y%m%d-%H%M%S"`
mkdir -p ~/logfiles/$var

#Submit the job script
for subj in $(ls ${SUBJ_DIR})
    do
    sbatch \
        -o ~/logfiles/${var}/output_${subj}.txt \
        -e ~/logfiles/${var}/error_${subj}.txt \
        ${SCRIPT_DIR}/3dDeconvolve_pred_job.sh \
        ${subj}
        sleep 1
done
