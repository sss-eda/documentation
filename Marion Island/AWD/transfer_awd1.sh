#!/bin/bash

# <About>
#_______________________________________________________________________________
# Copyright © 2019 SANSA. All rights reserved.
#
# DESCRIPTION:
#   This bash script transfers new data from the instrument PC to the data
#   server.
#
# NOTES:
#   * This script makes use of hard links in a hidden directory and rsync to
#     ensure that all data from the instrument PC is transferred to the data
#     server.
#
# VERSION HISTORY
#   2020/04/30 : Stephanus Schoeman :
#                First implementation of the MARAWD1 data transfer script.
#
# TODO:
#   * List here any suggestions for improving this script.
#_______________________________________________________________________________
# </About>



################################################################################
# Display the date of script execution.
################################################################################
clear
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo "                               Script executed at:"
echo "                          "`date`
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo ""
echo "                                      ****"
echo ""
################################################################################



################################################################################
# Initialize variables, directories and log files.
################################################################################
SCRIPT=$(readlink -f "$0")
THISPATH=$(dirname "$SCRIPT")

myINSTRUMENT="Automatic Whistler Detector"
mySHORT="MARAWD1"
myUSER="root"
myIP="172.18.30.111"
myDB="MARAWD1db"
mySOURCE1="/u1/marion/vr2"
mySOURCE2="/u2/marion/vr2"

myTARGET="/data/"$mySHORT
mySHADOW="/data/.shadows/"$mySHORT
myTEMP=$THISPATH/.rsync_transfer_list.tmp

mkdir -p $mySHADOW

myDATE=$(date +'%Y-%m-%d')

echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo "-> Transfer settings for "$myINSTRUMENT":"
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo "  * ABBREVIATION:  "$mySHORT
echo "  * USER:          "$myUSER
echo "  * IP:            "$myIP
echo "  * DATABASE:      "$myDB
echo "  * DATA SOURCE:   "$mySOURCE1", "$mySOURCE2
echo "  * ARCHIVE:       "$myTARGET
echo "  * SHADOW:        "$mySHADOW
echo ""
################################################################################



################################################################################
# Transfer data from instrument PC.
################################################################################
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo "-> Transferring data from instrument PC:"
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

rsync -av "$myUSER@$myIP:$mySOURCE1/wh_vr2_rt/" "$mySHADOW/" | tee $myTEMP
rsync -av "$myUSER@$myIP:$mySOURCE1/kesz/" "$mySHADOW/" | tee -a $myTEMP
rsync -av "$myUSER@$myIP:$mySOURCE2/wh_vr2_rt/" "$mySHADOW/" | tee -a $myTEMP
rsync -av "$myUSER@$myIP:$mySOURCE2/kesz/" "$mySHADOW/" | tee -a $myTEMP
# ls /data/.shadows/MARAWD1/ | tee $myTEMP
sed -i '/\/$/d' $myTEMP

echo ""
################################################################################



################################################################################
# Transfer data from instrument PC.
################################################################################
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo "-> Archiving files from shadow directory using hardlinks:"
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

> ./.transfer_data.txt

while read -r LINE; do
  reEXT='.marion.vr2$'
  if [[ $LINE =~ $reEXT ]]; then
    FILE=$(basename $LINE)

    reRAW='^[0-9]{4}-[0-9]{2}-[0-9]{2}UT[0-9]{2}:[0-9]{2}:[0-9]{2}.marion.vr2$'
    reEVENT='^[0-9]{4}-[0-9]{2}-[0-9]{2}UT[0-9]{2}:[0-9]{2}:[0-9]{2}.[0-9]{8}.marion.vr2$'

    if [[ $FILE =~ $reRAW ]]; then
      FILETYPE="RAW"
    elif [[ $FILE =~ $reEVENT ]]; then
      FILETYPE="EVENT"
    else
      FILETYPE="UNKNOWN"
    fi

    DATETIME=$(echo $FILE | sed -n 's/^\(.*\).marion.vr2$/\1/p')

    YEAR=$(date -d $DATETIME +'%Y')
    MONTH=$(date -d $DATETIME +'%m')
    DAY=$(date -d $DATETIME +'%d')
  else
    continue
  fi

  FILESIZE=$(ls -la $mySHADOW/$LINE | sed -n 's/\s\s*/,/gp' | cut -d',' -f5)

  TIMESTAMP=$(date -d $DATETIME +'%s')

  ENTRY=$mySHORT"status,filetype="$FILETYPE" size="$FILESIZE" "$TIMESTAMP"000000000"
  echo "$ENTRY" >> ./.transfer_data.txt

  mkdir -p $myTARGET/$FILETYPE/$YEAR/$MONTH/$DAY
  ln -f $mySHADOW/$LINE $myTARGET/$FILETYPE/$YEAR/$MONTH/$DAY/
  echo "  * "$LINE" -> "$myTARGET/$FILETYPE/$YEAR/$MONTH/$DAY
done < $myTEMP

TIMESTAMP=$(date +'%s')
ENTRY=$mySHORT"status transfer=1 "$TIMESTAMP"000000000"
echo "$ENTRY" >> ./.transfer_data.txt

curl -i -XPOST 'http://localhost:8086/write?db='$myDB --data-binary @./.transfer_data.txt


echo ""
################################################################################



################################################################################
# Script completed successfully.
################################################################################
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo "Done!"
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

exit 0
################################################################################
