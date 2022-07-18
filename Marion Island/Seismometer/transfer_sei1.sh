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
#   2020/05/03 : Stephanus Schoeman :
#                First implementation of the MARSEI1 data transfer script.
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

myINSTRUMENT="HartRAO Seismometer"
mySHORT="MARSEI1"
myUSER="nerd"
myIP="172.18.30.105"
myDB="MARSEI1db"
mySOURCE="/media/storage"

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

# rsync -av --exclude ".Trash-1000/*" "$myUSER@$myIP:$mySOURCE/" "$mySHADOW/" | tee $myTEMP
find /data/.shadows/MARSEI1/ -name "*.gcf" | tee $myTEMP
find /data/.shadows/MARSEI1/ -name "*.mseed" | tee -a $myTEMP
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
  reEXT='.gcf$|.mseed$'
  if [[ $LINE =~ $reEXT ]]; then
    FILE=$(basename $LINE)

    reGCF='^[0-9]{4}-[0-9]{2}-[0-9]{2}-[0-9]{5}-[0-9]{4}-[0-9]{4}-[0-9]+.gcf$'
    reMSEED='^[0-9]{4}\.[A-Z]{3}\.[0-9]{2}\.[0-9]+-[0-9]{4}.mseed$'

    if [[ $FILE =~ $reGCF ]]; then
      FILETYPE="GCF"

      YEAR=${FILE::4}
      MONTH=${FILE:5:2}
      DAY=${FILE:8:2}
      HOUR=${FILE:22:2}
      MINUTE=${FILE:24:2}
    elif [[ $FILE =~ $reMSEED ]]; then
      FILETYPE="MSEED"

      DIRDATE=$(basename $(dirname $LINE))
      YEAR=${DIRDATE::4}
      MONTH=${DIRDATE:5:2}
      DAY=${DIRDATE:8:2}
      HOUR=${FILE:14:2}
      MINUTE=${FILE:16:2}
    else
      FILETYPE="UNKNOWN"
    fi

    DATETIME=$(date -d "$YEAR-$MONTH-$DAY $HOUR:$MINUTE:00")
  else
    continue
  fi

  # FILESIZE=$(ls -la $mySHADOW/$LINE | sed -n 's/\s\s*/,/gp' | cut -d',' -f5)
  FILESIZE=$(ls -la $LINE | sed -n 's/\s\s*/,/gp' | cut -d',' -f5)

  TIMESTAMP=$(date -d "$DATETIME" +'%s')

  ENTRY=$mySHORT"status,filetype="$FILETYPE" size="$FILESIZE" "$TIMESTAMP"000000000"
  echo "$ENTRY" >> ./.transfer_data.txt

  mkdir -p $myTARGET/$FILETYPE/$YEAR/$MONTH/$DAY
  # ln -f $mySHADOW/$LINE $myTARGET/$FILETYPE/$YEAR/$MONTH/$DAY/
  ln -f $LINE $myTARGET/$FILETYPE/$YEAR/$MONTH/$DAY/
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