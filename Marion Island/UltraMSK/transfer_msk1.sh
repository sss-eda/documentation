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
#   2020/05/01 : Stephanus Schoeman :
#                First implementation of the MARMSK1 data transfer script.
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

myINSTRUMENT="UltraMSK"
mySHORT="MARMSK1"
myUSER="ultramsk"
myIP="172.18.30.121"
myDB="MARMSK1db"
mySOURCE="/home/ultramsk/data"

myTARGET="/data/"$mySHORT
mySHADOW="/data/.shadows/"$mySHORT
myTEMP=$THISPATH/.rsync_transfer_list.tmp

mkdir -p $mySHADOW

touch $myTEMP

TRANSFER=$(date +'%s')

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

rsync -av "$myUSER@$myIP:$mySOURCE/" "$mySHADOW/" | tee $myTEMP
# find /data/.shadows/MARMSK1/ -name "*.bin" | tee $myTEMP
# find /data/.shadows/MARMSK1/ -name "*.png" | tee -a $myTEMP
# find /data/.shadows/MARMSK1/ -name "*.txt" | tee -a $myTEMP
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
  reEXT='MAR.bin$|MAR.png$|.txt$'
  if [[ $LINE =~ $reEXT ]]; then
    FILE=$(basename $LINE)

    reBIN='^[0-9]{2}\.[0-9]{2}_[EWNS]{2}_[0-9]{8}_MAR.bin$'
    rePNG='^[0-9]{2}\.[0-9]{2}_[EWNS]{2}_[0-9]{8}_MAR.png$'
    reTXT='^[A-Z]{3}_(EW|NS)_MAR_[0-9]{8}.txt$'

    if [[ $FILE =~ $reBIN ]]; then
      FILETYPE=${FILE:0:8}
      YEAR=${FILE:9:4}
      MONTH=${FILE:13:2}
      DAY=${FILE:15:2}
    elif [[ $FILE =~ $rePNG ]]; then
      FILETYPE=${FILE:0:8}"_PNG"
      YEAR=${FILE:9:4}
      MONTH=${FILE:13:2}
      DAY=${FILE:15:2}
    elif [[ $FILE =~ $reTXT ]]; then
      FILETYPE=${FILE:0:6}
      YEAR=${FILE:11:4}
      MONTH=${FILE:15:2}
      DAY=${FILE:17:2}
    else
      continue
      # FILETYPE="UNKNOWN"
      # YEAR=$(date +'%Y')
      # MONTH=$(date +'%m')
      # DAY=$(date +'%d')
    fi

    TIMESTAMP=$(date -d "$YEAR-$MONTH-$DAY" +'%s')
  else
    continue
  fi

  FILESIZE=$(ls -la $mySHADOW/$LINE | sed -n 's/\s\s*/,/gp' | cut -d',' -f5)
  # FILESIZE=$(ls -la $LINE | sed -n 's/\s\s*/,/gp' | cut -d',' -f5)

  ENTRY="status,filetype="$FILETYPE" filename=\""$FILE"\",size="$FILESIZE",etl=0 "$TIMESTAMP"000000000"
  echo "$ENTRY" >> $THISPATH/.transfer_data.txt

  mkdir -p $myTARGET/$YEAR/$MONTH/$DAY
  ln -f $mySHADOW/$LINE $myTARGET/$YEAR/$MONTH/$DAY/
  # ln -f $LINE $myTARGET/$YEAR/$MONTH/$DAY/
  echo "  * "$mySHADOW/$LINE" -> "$myTARGET/$YEAR/$MONTH/$DAY
done < $myTEMP

ENTRY="status transfer=1 "$TRANSFER"000000000"
echo "$ENTRY" >> $THISPATH/.transfer_data.txt
################################################################################



################################################################################
# Load status data onto InfluxDB.
################################################################################
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo "-> Load status data onto InfluxDB:"
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# -i is to specify that input file to be used with the POST
# -XPOST is tell curl to send the data using POST and not GET over HTTP
# -f is to fail silently. Will just return error codes
# -s is to specify silent mode for curl, so output does not get written to
#     log files etc.
CURL=$(curl -i -XPOST -s 'http://localhost:8086/write?db='$myDB --data-binary @$THISPATH/.transfer_data.txt)
CURL_STATUS=$?

if [ $CURL_STATUS -lt 0 ]; then
  echo "  * Failed: "
  echo "$CURL"
else
  echo "  * Success"
  rm $THISPATH/.transfer_data.txt
  rm $myTEMP
fi

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