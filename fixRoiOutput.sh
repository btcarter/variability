#!/bin/bash

START_DIR=$(pwd)
WORK_DIR=~/compute/Reading/results/Group_Analysis2/predictability3
ROI_FILE=${WORK_DIR}/roiStats.txt
OUTPUT=${WORK_DIR}/roiStatsEdited.txt
LINES=$(wc -l < $ROI_FILE)

#COMMANDS

declare -i $LINES

for i in {0..$LINES};
    do
    sed -e '$i d' $ROI_FILE >> $OUTPUT ##delete every second line starting with the third line to get rid of the headers
done

sed -E `s/\/fslhome\/ben88\/compute\/Reading\/Compute_data\/SubjData\/(Luke_Reading_S\d+)\/afni_data\/predictability3\/predictability_deconv_blur5_ANTS_resampled\+tlrc\[5\]_0\[ORTHO_GLT\]/\1/g` $ROI_FILE > $OUTPUT #clip names so only subject name exists instead of the full file path.

# END
