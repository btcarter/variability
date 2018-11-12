#!/bin/bash

#Written by Ben Carter, 11/9/2018
#This script will create both a functional ROI mask and output an RAI table with coordinates for the CM and MI for those ROIs.
#Dependencies: AFNI

#environmental variables
START=$(pwd)    #starting directory
PROJECT=/Users/ben88/Documents/Research/fMRI_data/Reading   #home directory
SUBJ_DIR=$PROJECT/Compute_data/SubjData                     #directory with individual subject data
GROUP_DIR=$PROJECT/results/Group_Analysis2/predictability3  #directory with group results
GROUP_FILE=$GROUP_DIR/pred_lsa+tlrc.HEAD                    #group results file
WORK_DIR=$GROUP_DIR                                         #working directory or where you want your output files to be created.
TABLE=$WORK_DIR/roiTable                                    #output table
MASTER=$GROUP_DIR/cthulhu_mni+tlrc                          #anatomical template must manually update this below
RADIUS=7.5

#set working directory
WORK_DIR=$GROUP_DIR
cd $WORK_DIR

#Commands
FUNCTIONAL_MASK="3dclust -1Dformat -orient LPI -1dindex 4 -1tindex 5 -2thresh -3.291 3.291 -dxyz=1 -savemask functionalROIMask 1.01 38"

#make functional roi mask and summary table
touch ${TABLE}.1D
$FUNCTIONAL_MASK $GROUP_FILE >> $TABLE.1D

#output coordinate data for most active voxels and center of mass
1dcat ${TABLE}.1D'[1..3]' > ${TABLE}_CM.1D
1dcat ${TABLE}.1D'[13..15]' > ${TABLE}_MI.1D

#afni makes the spherical mask
3dUndump -prefix sphereROI_CM -master $MASTER -orient LPI -srad $RADIUS -xyz ${TABLE}_CM.1D
3dUndump -prefix sphereROI_MI -master $MASTER -orient LPI -srad $RADIUS -xyz ${TABLE}_MI.1D

cd $START
