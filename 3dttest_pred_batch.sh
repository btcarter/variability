#!/bin/bash

#######################################
#PREPROCESSING BATCH SUBMISSION SCRIPT#
#######################################

#Written by Ben Carter 03/27/2017

#############
#ENVIRONMENT#
#############

HOME_DIR=/fslhome/ben88/compute/Reading
SCRIPT_DIR=${HOME_DIR}/analyses/variability
SUBJ_DIR=${HOME_DIR}/mriData

##########
#COMMANDS#
##########

#Create logfiles directory
var=`date +"%Y%m%d-%H%M%S"`
mkdir -p ~/logfiles/$var

#Submit the job script
sbatch \
    -o ~/logfiles/${var}/output_group_fixDur.txt \
    -e ~/logfiles/${var}/error_group_fixDur.txt \
    ${SCRIPT_DIR}/3dttest_pred_job.sh \
    sleep 1

