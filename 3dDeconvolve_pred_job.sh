#!/bin/sh

#SBATCH --time=06:00:00   # walltime
#SBATCH --ntasks=1   # number of processor cores (i.e. tasks)
#SBATCH --nodes=1   # number of nodes
#SBATCH --mem-per-cpu=16384M  # memory per CPU core
#SBATCH -J "decon3"  # job name

# Compatibility variables for PBS. Delete if not needed.
export PBS_NODEFILE=`/fslapps/fslutils/generate_pbs_nodefile`
export PBS_JOBID=$SLURM_JOB_ID
export PBS_O_WORKDIR="$SLURM_SUBMIT_DIR"
export PBS_QUEUE=batch

# Set the max number of threads to use for programs using OpenMP.
export OMP_NUM_THREADS=$SLURM_CPUS_ON_NODE

###############
#ENVIRONMENTAL#
###############


AFNI_BIN=/fslhome/ben88/abin #where to find the afni scripts
HOME_DIR=/fslhome/ben88/compute/Reading #study directory
SCRIPT_DIR=${HOME_DIR}/analyses/variability #where your scripts are
antifyFunk=$SCRIPT_DIR/ANTifyFunctional #where Brock's antify script lives
subj_DIR=${HOME_DIR}/mriData/${1} #where the individual subject's data are found
TEMPLATE=~/templates/Cthulhu #where your anatomical template is found
TIMING=${HOME_DIR}/timingFiles/variability #directory for HDF of timing files
FIXATION=$TIMING/fixationCross.txt #where fixation cross files are for the subject
READING=$TIMING/readingBlock.txt #where reading block files are for the subject
LOG=/fslhome/ben88/logfiles #where to write output and error logs for this subject
PREFIX=variability #the prefix your are using for this analysis

##########
#COMMANDS#
##########

#  Created by Benjamin Carter on 11/27/2018.
#  This script performs Ordinary Least Square Regression of subject data using 3dDeconvolve from the AFNI software package.


cd $subj_DIR
cd afni_data

if [ ! -d $PREFIX ]
    then
        mkdir $PREFIX
fi

cd $PREFIX

#####################
#REGRESSION ANALYSIS#
#####################



if [ -f $FIXATION ] && [ ! -f $PREFIX+orig.BRIK ]
    then
        #3dDeconvolve
        ${AFNI_BIN}/3dDeconvolve \
            -input $subj_DIR/afni_data/epi1_volreg+orig $subj_DIR/afni_data/epi2_volreg+orig $subj_DIR/afni_data/epi3_volreg+orig \
            -mask $subj_DIR/afni_data/struct_mask+orig \
            -polort A \
            -num_stimts 8 \
            -stim_file 1 "$subj_DIR/motion/motion.txt[0]" -stim_label 1 "Roll"  -stim_base   1 \
            -stim_file 2 "$subj_DIR/motion/motion.txt[1]" -stim_label 2 "Pitch" -stim_base   2 \
            -stim_file 3 "$subj_DIR/motion/motion.txt[2]" -stim_label 3 "Yaw"   -stim_base   3 \
            -stim_file 4 "$subj_DIR/motion/motion.txt[3]" -stim_label 4 "dS"    -stim_base   4 \
            -stim_file 5 "$subj_DIR/motion/motion.txt[4]" -stim_label 5 "dL"    -stim_base   5 \
            -stim_file 6 "$subj_DIR/motion/motion.txt[5]" -stim_label 6 "dP"    -stim_base   6 \
            -stim_times 7 ${FIXATION} 'BLOCK(6,1)' -stim_label 7 "FIX" \
            -stim_times 8 ${READING} 'BLOCK(12,1)' -stim_label 8 "READ" \
            -num_glt 3 \
            -gltsym 'SYM: FIX' \
            -glt_label 1 FIX \
            -gltsym 'SYM: READ' \
            -glt_label 2 READ \
            -gltsym 'SYM: READ-FIX' \
            -glt_label 3 READ-FIX \
            -censor "$subj_DIR/motion/motion_censor_vector.txt[0]" \
            -nocout \
            -tout \
            -bucket $PREFIX_deconv \
            -xjpeg $PREFIX_design.jpg \
            -jobs 2 \
            -GOFORIT 12
fi



#blur the output of the regression analysis
if [ -f $PREFIX_deconv+orig.BRIK ] && [ ! -f $PREFIX_deconv_blur5+orig.BRIK ]
    then
        ${AFNI_BIN}/3dmerge -prefix $PREFIX_deconv_blur5 -1blur_fwhm 5.0 -doall $PREFIX_deconv+orig
fi
