#!/bin/bash

#######################################
#PREPROCESSING BATCH SUBMISSION SCRIPT#
#######################################

#Written by Ben Carter 03/27/2017

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
sbatch \
    -o ~/logfiles/${var}/output_group_fixDur.txt \
    -e ~/logfiles/${var}/error_group_fixDur.txt \
    ${SCRIPT_DIR}/3dttest_pred_job.sh \
    sleep 1

