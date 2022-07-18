#!/bin/bash
#############################################################################
#	Script to archieve the Quicklooks plots of UltraMSK
#############################################################################
clear
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo "				Script executed at:"
echo "				"`date`
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo ""
echo "				****"
#############################################################################
YEAR=$(date -d "yesterday" +'%Y')
MONTH=$(date -d "yesterday" +'%m')
DAY=$(date -d "yesterday" +'%d')

DATAPATH="/home/engineer/msk1/quicklooks/"$YEAR"/"$MONTH"/"$DAY
DESTINATION="/home/sansa/msk1/"

tar -czvf MARMSK1.tar.gz $DATAPATH 
############################################################################

echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo "Script completed successfully"
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

exit 0
############################################################################

