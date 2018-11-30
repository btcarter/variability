#!/bin/bash

#######################################
#PREPROCESSING BATCH SUBMISSION SCRIPT#
#######################################

#Written by Ben Carter 01/10/2017

#############
#ENVIRONMENT#
#############

PREFIX=variability #the prefix your are using for this analysis
HOME_DIR=/fslhome/ben88/compute/Reading #project directory
SCRIPT_DIR=${HOME_DIR}/analyses/${PREFIX} #analysis script location
SUBJ_DIR=${HOME_DIR}/mriData #subject data location

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
        ${SCRIPT_DIR}/ants_trans_pred_job.sh \
        ${subj}
        sleep 1
done
