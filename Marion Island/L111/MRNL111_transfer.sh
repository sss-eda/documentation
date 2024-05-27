#!/bin/bash

# <About>
#_______________________________________________________________________________
# Copyright © 2024 SANSA. All rights reserved.
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
#   2020/04/27 : Stephanus Schoeman :
#                First implementation of the MARLEM1 data transfer script.
#   2020/06/04 : Stephanus Schoeman :
#                Changing the way data is being logged to influxDB so it can
#                better utilised by the ETL pipeline.
#   2024/05/15 : DJ van Wyk:
#                Adopted the script to a new naming convention and changed
#                the timestamp entry to reduce decimal places.
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

myINSTRUMENT="Magnetometer"
mySHORT="MRNL112"
myUSER="sansa"
myIP="172.18.30.102"
myDB="MRNL112db"
mySOURCE="/data/MRNL112/R"

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
# find /data/.shadows/MRNL111/ -name *.dat | tee $myTEMP
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
  reEXT='\.dat$'
  if [[ $LINE =~ $reEXT ]]; then
    FILE=$(basename $LINE)

    reDAILY='^MRNL112-[0-9]{4}[0-9]{2}[0-9]{2}.dat$'

    if [[ $FILE =~ $reDAILY ]]; then
      FILETYPE="DAILY"
    else
      FILETYPE="UNKNOWN"
    fi

    DATETIME=$(echo $FILE | sed -n 's/^MRNL112\(.*\).dat$/\1/p')

    YEAR=$(date -d $DATETIME +'%Y')
    MONTH=$(date -d $DATETIME +'%m')
    DAY=$(date -d $DATETIME +'%d')

    TIMESTAMP=$(date -d "$DATETIME" +'%S') #%s seconds since epoch
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
  echo "  * Successfull transfer!"
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
