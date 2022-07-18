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
#   2020/05/04 : Stephanus Schoeman :
#                First implementation of the MARDOP1 data transfer script.
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

myINSTRUMENT="Narrow Band VLF Doppler Receiver"
mySHORT="MARDOP1"
myUSER="DOPPLER"
myIP="172.18.30.107"
myDB="MARDOP1db"
mySOURCE="/mnt/mardop1_mount"

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
echo "  * DATA SOURCE:   "$mySOURCE
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

rsync -av "$mySOURCE/" "$mySHADOW/" | tee $myTEMP
# find /data/.shadows/MARDOP1/ -name "*.dop" | tee $myTEMP
# find /data/.shadows/MARDOP1/ -name "*.raw" | tee -a $myTEMP
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
  reEXT='.dop$|.raw$'
  if [[ $LINE =~ $reEXT ]]; then
    FILE=$(basename $LINE)

    reDOP='^[A-Z,a-z]{3}[0-9]{6}.dop$'
    reRAW='^[A-Z,a-z]{3}[0-9]{6}_[0-9]{4}.raw$'
    
    if [[ $FILE =~ $reDOP ]]; then
      FILETYPE="DOP"

      HOUR=00
      MINUTE=00
    elif [[ $FILE =~ $reRAW ]]; then
      FILETYPE="RAW"

      HOUR=${FILE:10:2}
      MINUTE=${FILE:12:2}
    else
      FILETYPE="UNKNOWN"

      HOUR=00
      MINUTE=00
    fi

    YEAR="20"${FILE:3:2}
    MONTH=${FILE:5:2}
    DAY=${FILE:7:2}

    DATETIME=$(date -d "$YEAR-$MONTH-$DAY $HOUR:$MINUTE:00")
  else
    continue
  fi

  FILESIZE=$(ls -la $mySHADOW/$LINE | sed -n 's/\s\s*/,/gp' | cut -d',' -f5)
  # FILESIZE=$(ls -la $LINE | sed -n 's/\s\s*/,/gp' | cut -d',' -f5)

  TIMESTAMP=$(date -d "$DATETIME" +'%s')

  ENTRY=$mySHORT"status,filetype="$FILETYPE" size="$FILESIZE" "$TIMESTAMP"000000000"
  echo "$ENTRY" >> ./.transfer_data.txt

  mkdir -p $myTARGET/$FILETYPE/$YEAR/$MONTH/$DAY
  ln -f $mySHADOW/$LINE $myTARGET/$FILETYPE/$YEAR/$MONTH/$DAY/
  # ln -f $LINE $myTARGET/$FILETYPE/$YEAR/$MONTH/$DAY/
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
