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
#                First implementation of the MARVLF2 data transfer script.
#   2020/06/06 : Stephanus Schoeman :
#                Changed to work with new python ETL pipeline.
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

myINSTRUMENT="Digital VLF Recording and Analysis System"
mySHORT="MARVLF2"
myUSER="dvras"
myIP="172.18.30.103"
myDB="MARVLF2db"
mySOURCE1="/home/dvras/archive"
mySOURCE2="/home/dvras/data"

myTARGET="/data/"$mySHORT
mySHADOW="/data/.shadows/"$mySHORT
myTEMP=$THISPATH/.rsync_transfer_list.tmp

touch $myTEMP

mkdir -p $mySHADOW

TRANSFER=$(date +'%s')

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

rsync -av --exclude '*nohup.out' "$myUSER@$myIP:$mySOURCE1/" "$mySHADOW/" | tee $myTEMP
rsync -av --exclude '*nohup.out' "$myUSER@$myIP:$mySOURCE2/" "$mySHADOW/" | tee -a $myTEMP
# ls /data/.shadows/MARVLF2/ | tee $myTEMP
sed -i '/\/$/d' $myTEMP

echo ""
################################################################################



################################################################################
# Transfer data from instrument PC.
################################################################################
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo "-> Archiving files from shadow directory using hardlinks:"
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

while read -r LINE; do
  reEXT='[0-9]{8}_[0-9]{6}_MAR.wav(.bz2)*$'
  if [[ $LINE =~ $reEXT ]]; then
    FILE=$(basename $LINE)

    reWAV='^[0-9]{8}_[0-9]{6}_MAR.wav$'
    reBZ2='^[0-9]{8}_[0-9]{6}_MAR.wav.bz2$'

    if [[ $FILE =~ $reWAV ]]; then
      FILETYPE="WAV"
    elif [[ $FILE =~ $reBZ2 ]]; then
      FILETYPE="BZ2"
    else
      continue
      # FILETYPE="UNKNOWN"
    fi

    YEAR=${FILE::4}
    MONTH=${FILE:4:2}
    DAY=${FILE:6:2}
    HOUR=${FILE:9:2}
    MINUTE=${FILE:11:2}
    SECOND=${FILE:13:2}

    TIMESTAMP=$(date -d "$YEAR-$MONTH-$DAY $HOUR:$MINUTE:$SECOND" +'%s')
  else
    continue
  fi

  FILESIZE=$(ls -la $mySHADOW/$LINE | sed -n 's/\s\s*/,/gp' | cut -d',' -f5)

  ENTRY="status,filetype="$FILETYPE" filename=\""$FILE"\",size="$FILESIZE",etl=0 "$TIMESTAMP"000000000"
  echo "$ENTRY" >> $THISPATH/.transfer_data.txt

  mkdir -p $myTARGET/$YEAR/$MONTH/$DAY
  ln -f $mySHADOW/$LINE $myTARGET/$YEAR/$MONTH/$DAY/
  echo "  * "$LINE" -> "$myTARGET/$YEAR/$MONTH/$DAY
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