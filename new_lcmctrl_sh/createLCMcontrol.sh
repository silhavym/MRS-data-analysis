#!/bin/sh
# "createLCMcontrol.sh" [version 0.1 beta] - this version is early release, there might be bugs to fix in the future
# By: Peter Truong, SRI, 2025
# This script takes in 2 or three inputs to output a control file for your specific sequence
# This assumes that your folder structure is:
#       "study01/subj01/scan01/lcm_data"
#       "study01/subj01/scan01_w/lcm_data"
#
# Inputs:
#        ${1} = fullpath to the template control file you wish to use
#        ${2} = fullpath to the metabolite LCModel data file
#        ${3} = (optional) fullpath to the water reference LCModel data file
# Output:
#        The output will be a control file located within the same directory as the metabolite LCModel data file
#
# This can also be used to automatically run LCModel, just need to make sure the last line "~/.lcmodel/bin/lcmodel < ${CONTROL_FULLFILE}" is uncommented

TEMPLATE_CONTROL=$(realpath "${1}")
METAB_FULLFILE=$(realpath "${2}")
TMP_CONTROL_FILE="$(basename "$TEMPLATE_CONTROL")"
CONTROL_FILE="${TMP_CONTROL_FILE:4}"
METAB_DIR="$(dirname "$METAB_FULLFILE")"
METAB_FOLD="$(basename "$METAB_DIR")"
SUBJ_DIR="$(dirname "$METAB_DIR")"
SUBJ_FOLD="$(basename "$SUBJ_DIR")"
TITLE_OUT="${SUBJ_FOLD}_${METAB_FOLD}"
CONTROL_FULLFILE="${METAB_DIR}/${CONTROL_FILE}"
cp $TEMPLATE_CONTROL ${CONTROL_FULLFILE}
METAB_FULLFILE_ESCAPED=$(echo "$METAB_FULLFILE" | sed 's/\//\\\//g')
sed -i "s/replace_metab/${METAB_FULLFILE_ESCAPED}/g" ${CONTROL_FULLFILE}
sed -i "s/replace_title/${TITLE_OUT}/g" ${CONTROL_FULLFILE}
if [ "$#" -eq 2 ]
then
	sed -i "/replace_water/d" ${CONTROL_FULLFILE}
	sed -i "/setECC/d" ${CONTROL_FULLFILE}
	sed -i "/setWS/d" ${CONTROL_FULLFILE}
else
    WATER_FULLFILE=$(realpath "${3}")
    WATER_DIR="$(dirname "$WATER_FULLFILE")"
    WATER_FOLD="$(basename "$WATER_DIR")"
    WATER_FULLFILE_ESCAPED=$(echo "$WATER_FULLFILE" | sed 's/\//\\\//g')
	sed -i "s/replace_water/${WATER_FULLFILE_ESCAPED}/g" ${CONTROL_FULLFILE}
	if [[ "$TEMPLATE_CONTROL_FILE" == *"MEGA"* ]]; then
		sed -i "s/setECC/DOECC=T/d" ${CONTROL_FULLFILE}
	else
		sed -i "s/setECC/DOECC=T/g" ${CONTROL_FULLFILE}
	fi
	sed -i "s/setWS/DOWS=T/g" ${CONTROL_FULLFILE}
fi
chmod 'u+x' ${CONTROL_FULLFILE}
#echo "running LCmodel"
/opt/software/lcmodel/bin/lcmodel < ${CONTROL_FULLFILE}
#echo "running LCModel complete"
