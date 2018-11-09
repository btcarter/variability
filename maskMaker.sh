#!/bin/bash

#Written by Ben Carter, 11/9/2018
#This script will create both a functional ROI mask from group statistical results as well as spherical ROI mask using the center of mass to look at participant variability.
#Dependencies: AFNI

#environmental variables
PROJECT=Users/ben88/Documents/Research/fMRI_data/Reading    #home directory
SUBJ_DIR=$PROJECT/Compute_data/SubjData                     #directory with individual subject data
GROUP_DIR=$PROJECT/results/Group_Analysis2/predictability3  #directory with group results
GROUP_FILE=$GROUP_DIR/pred_lsa+tlrc.HEAD                    #group results file
TABLE=$GROUP_DIR/functionalTable.txt                        #output table

#Commands
FUNCTIONAL_MASK="3dclust -1Dformat -nosum -1dindex 4 -1tindex 5 -2thresh -3.291 3.291 -dxyz=1 -savemask functionalMask 1.01 38"
COORDINATES="3dclust -1Dformat -nosum -1dindex 4 -1tindex 5 -2thresh -3.291 3.291 -dxyz=1 1.01 38"

#make functional roi mask
$FUNCTIONAL_MASK $GROUP_FILE

#output coordinate data for most active voxels and center of mass
touch $TABLE
$COORDINATES $GROUP_FILE >> $TABLE

#make spherical ROI mask using coordinates file
