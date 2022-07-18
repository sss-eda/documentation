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
#                First implementation of the MARGST1 data transfer script.
#   2020/06/04 : Stephanus Schoeman :
#                Changing the way data is being logged to influxDB so it can
#                better utilised by the ETL pipeline.
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

myINSTRUMENT="GNSS Scintillation Receiver"
mySHORT="MARGST1"
myUSER="nerd"
myIP="172.18.30.101"
myDB="MARGST1db"
mySOURCE="/home/nerd/data"

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
#find /data/.shadows/MARGST1/ -name "*.*" | tee $myTEMP
#ls /data/.shadows/MARGST1/*/ | tee $myTEMP
sed -i '/\/$/d' $myTEMP

echo ""
################################################################################



################################################################################
# Archive files from shadow directory using hardlinks.
################################################################################
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo "-> Archiving files from shadow directory using hardlinks:"
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

while read -r LINE; do
  reEXT='\.tar\.bz2$|\.ism$|\.msg$|\.nvd$|\.obs$|\.obsb$|\.pin$|\.psn$|\.rlt$|\.rng$|\.rsb$|\.scn$|\.sinb$|\.snr$|\.use$'
  if [[ $LINE =~ $reEXT ]]; then
    FILE=$(basename $LINE)

    reBZ2='^[0-9]{6}.tar.bz2$'
    reISM='^[0-9]{6}_[0-9]{6}.ism$'
    reMSG='^[0-9]{6}_[0-9]{6}.msg$'
    reNVD='^[0-9]{6}_[0-9]{6}.nvd$'
    reOBS='^[0-9]{6}_[0-9]{6}.obs$'
    reOBSB='^[0-9]{6}_[0-9]{6}.obsb$'
    rePIN='^[0-9]{6}_[0-9]{6}.pin$'
    rePSN='^[0-9]{6}_[0-9]{6}.psn$'
    reRLT='^[0-9]{6}_[0-9]{6}.rlt$'
    reRNG='^[0-9]{6}_[0-9]{6}.rng$'
    reRSB='^[0-9]{6}_[0-9]{6}.rsb$'
    reSCN='^[0-9]{6}_[0-9]{6}.scn$'
    reSINB='^[0-9]{6}_[0-9]{6}.sinb$'
    reSNR='^[0-9]{6}_[0-9]{6}.snr$'
    reUSE='^[0-9]{6}_[0-9]{6}.use$'

    if [[ $FILE =~ $reBZ2 ]]; then
      FILETYPE="BZ2"
    elif [[ $FILE =~ $reISM ]]; then
      FILETYPE="ISM"
    elif [[ $FILE =~ $reMSG ]]; then
      FILETYPE="MSG"
    elif [[ $FILE =~ $reNVD ]]; then
      FILETYPE="NVD"
    elif [[ $FILE =~ $reOBS ]]; then
      FILETYPE="OBS"
    elif [[ $FILE =~ $reOBSB ]]; then
      FILETYPE="OBSB"
    elif [[ $FILE =~ $rePIN ]]; then
      FILETYPE="PIN"
    elif [[ $FILE =~ $rePSN ]]; then
      FILETYPE="PSN"
    elif [[ $FILE =~ $reRLT ]]; then
      FILETYPE="RLT"
    elif [[ $FILE =~ $reRNG ]]; then
      FILETYPE="RNG"
    elif [[ $FILE =~ $reRSB ]]; then
      FILETYPE="RSB"
    elif [[ $FILE =~ $reSCN ]]; then
      FILETYPE="SCN"
    elif [[ $FILE =~ $reSINB ]]; then
      FILETYPE="SINB"
    elif [[ $FILE =~ $reSNR ]]; then
      FILETYPE="SNR"
    elif [[ $FILE =~ $reUSE ]]; then
      FILETYPE="USE"
    else
      FILETYPE="UNKNOWN"
    fi

    YEAR=20${FILE::2}
    MONTH=${FILE:2:2}
    DAY=${FILE:4:2}
    if [[ $FILE =~ $reBZ2 ]]; then
      HOUR="00"
      MINUTE="00"
      SECOND="00"
    else
      HOUR=${FILE:7:2}
      MINUTE=${FILE:9:2}
      SECOND=${FILE:11:2}
    fi

    TIMESTAMP=$(date -d "$YEAR-$MONTH-$DAY $HOUR:$MINUTE:$SECOND" +'%s')
  else
    continue
  fi

  FILESIZE=$(ls -la $mySHADOW/$LINE | sed -n 's/\s\s*/,/gp' | cut -d',' -f5)
  #FILESIZE=$(ls -la $LINE | sed -n 's/\s\s*/,/gp' | cut -d',' -f5)

  ENTRY="status,filetype="$FILETYPE" filename=\"$FILE\",size="$FILESIZE",etl=0 "$TIMESTAMP"000000000"
  echo "$ENTRY" >> $THISPATH/.transfer_data.txt

  mkdir -p $myTARGET/$YEAR/$MONTH/$DAY
  ln -f $mySHADOW/$LINE $myTARGET/$YEAR/$MONTH/$DAY/
  #ln -f $LINE $myTARGET/$YEAR/$MONTH/$DAY/
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
