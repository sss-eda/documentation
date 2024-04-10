#!/bin/bash

# <About>
#_______________________________________________________________________________
# Copyright © 2024 SANSA. All rights reserved.
#
# DESCRIPTION:
#   This bash script provides a user friendly way to log activities on any of
#   SANSA instruments or PCs at Marion Island Research base.
#
# NOTES:
#   * This script needs to be called manually whenever an event has to be
#     logged.
#
# VERSION HISTORY
#   2018/07/23 : Stephanus Schoeman : First instance of universal activity
#                                     logger.
#   2024/03/13 : DJ van Wyk : Adapted for use on the Marion Island Systems.
#
# TODO:
#   * List any improvements or suggestions here.
#_______________________________________________________________________________
# </About>



################################################################################
# Initialize variables, directories and files.
################################################################################
SCRIPT=$(readlink -f "$0")
THISPATH=$(dirname "$SCRIPT")
CONFIG=$THISPATH/Marionlog.conf

YEAR=$(date +'%Y')
MONTH=$(date +'%m')
DAY=$(date +'%d')
D=$YEAR-$MONTH-$DAY

HOUR=$(date +'%H')
MINUTE=$(date +'%M')
T=$HOUR:$MINUTE

TIME_RE='^[0-1][0-9]:[0-5][0-9]$|^2[0-3]:[0-5][0-9]$'
DATE_RE='^[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]$'
PERSON_RE='^none$'

MON_PATH="/home/odin/logger"
################################################################################



################################################################################
# Display the date of script execution.
################################################################################
clear

printf "%0.s~" {1..80}
echo ""
echo "                               Script executed at:"
echo "                          "`date`
printf "%0.s~" {1..80}
echo ""

echo ""
echo "                                      ****"
echo ""
################################################################################



################################################################################
# User chooses instrument
################################################################################
clear

printf "%0.s~" {1..80}
echo ""
echo "~ Please select one of the following instruments:"
printf "%0.s~" {1..80}
echo ""

awk -F, 'BEGIN {OFS = "\t"} {print $1, $3}' $CONFIG
echo ""

while read -p '-> Instrument number: ' OPTION
do
  INSTRUMENT=$(awk -F, -v var="$OPTION" '$1 == var { print $2 }' $CONFIG)
  if [ -z $INSTRUMENT ]
  then
    echo "! Invalid option. Please try again."
    echo ""
  else
    break
  fi
done

MY_USER=$(awk -F, -v var="$OPTION" '$1 == var { print $4 }' $CONFIG)
MY_IP=$(awk -F, -v var="$OPTION" '$1 == var { print $5 }' $CONFIG)
MY_PERSON=$(awk -F, -v var="$OPTION" '$1 == var { print $6 }' $CONFIG)
MY_DB=$(awk -F, -v var="$OPTION" '$1 == var { print $7 }' $CONFIG)
MY_TABLE=$(awk -F, -v var="$OPTION" '$1 == var { print $8 }' $CONFIG)
MY_PATH=$(awk -F, -v var="$OPTION" '$1 == var { print $9 }' $CONFIG)

CURPATH=$THISPATH/$INSTRUMENT
if [ ! -d $CURPATH ]
then
  mkdir $CURPATH
fi

echo ""
################################################################################



################################################################################
# Get name of user logging the activity
################################################################################
clear

printf "%0.s~" {1..80}
echo ""
echo "~ Please enter the name of the responsible person:"
printf "%0.s~" {1..80}
echo ""

while read -p '-> First name (DEFAULT '$MY_PERSON') : ' PERSON
do
  if [ -z $PERSON ]
  then
    PERSON=$MY_PERSON
  fi
  if [[ $PERSON =~ $PERSON_RE ]]
  then
    echo "! Invalid entry. Please try again."
    echo ""
  else
    break
  fi
done

echo ""
################################################################################



################################################################################
# Get date of event
################################################################################
clear

printf "%0.s~" {1..80}
echo ""
echo "~ Please enter the date of the event: "
printf "%0.s~" {1..80}
echo ""

while read -p '-> Date (DEFAULT '$D') : ' DATE
do
  if [ -z $DATE ]
  then
    DATE=$D
  fi
  if [[ $DATE =~ $DATE_RE ]]
  then
    break
  else
    echo "! Invalid entry. Please try again."
    echo ""
  fi
done

echo ""
################################################################################



################################################################################
# Get time of event
################################################################################
clear

printf "%0.s~" {1..80}
echo ""
echo "~ Please enter the time at which the event occurred: "
printf "%0.s~" {1..80}
echo ""

while read -p '-> Time (DEFAULT '$T') : ' TIME
do
  if [ -z $TIME ]
  then
    TIME=$T
  fi
  if [[ $TIME =~ $TIME_RE ]]
  then
    break
  else
    echo "! Invalid entry. Please try again."
    echo ""
  fi
done

TIMESTAMP=$(date -d "$DATE $TIME:00" +'%s')000000000
YEAR_=$(date -d "$DATE" +'%Y')
MONTH_=$(date -d "$DATE" +'%m')
DAY_=$(date -d "$DATE" +'%d')

if [ ! -d $CURPATH/$YEAR_ ]
then
  mkdir $CURPATH/$YEAR_
fi

echo ""
################################################################################



################################################################################
# Get current status of instrument
################################################################################
clear

printf "%0.s~" {1..80}
echo ""
echo "~ Please select the current status of the instrument from the list below: "
printf "%0.s~" {1..80}
echo ""

echo -e "0\toff"
echo -e "1\tinterrupted"
echo -e "2\ton"
echo ""

while read -p '-> Status : ' STATUS
do
  if [ -z "$STATUS" ]
  then
    STATUS=9
  fi
  if [ "$STATUS" = "0" ]
  then
    STATUS_="off\t"
    break
  elif [ "$STATUS" = "1" ]
  then
    STATUS_="interrupted"
    break
  elif [ "$STATUS" = "2" ]
  then
    STATUS_="on\t"
    break
  else
    echo "! Invalid entry. Please try again."
    echo ""
  fi
done

echo ""
################################################################################



################################################################################
# Get details of event
################################################################################
clear

printf "%0.s~" {1..80}
echo ""
echo "~ Please elaborate with some notes regarding the event: "
printf "%0.s~" {1..80}
echo ""

while read -p 'Notes : ' NOTES
do
  if [ -z "$NOTES" ]
  then
    echo "! Invalid entry. Please try again."
    echo ""
  else
    break
  fi
done

echo ""
################################################################################



################################################################################
# Create comma seperated log file and readable text file
################################################################################
LOGFILE=$CURPATH/$YEAR_/$INSTRUMENT"_"$YEAR_$MONTH_"00_000000.log"
touch $LOGFILE
echo $MY_TABLE" person=\""$PERSON"\",status="$STATUS",notes=\""$NOTES"\" "$TIMESTAMP >> $LOGFILE

#Add tab to person's name if it's too short.
TEXTFILE=$CURPATH/$YEAR_/$INSTRUMENT"_"$YEAR_$MONTH_"00_000000.txt"
if [ ! -f $TEXTFILE ]
then
  printf "%0.s-" {1..80} > $TEXTFILE
  echo "" >> $TEXTFILE
  echo -e "Day\tTime\tPerson\t\tStatus\t\tDescription" >> $TEXTFILE
  printf "%0.s-" {1..80} >> $TEXTFILE
  echo "" >> $TEXTFILE
fi
echo -e $DAY_"\t"$TIME"\t"$PERSON"\t"$STATUS_"\t"$NOTES >> $TEXTFILE
################################################################################



################################################################################
# Sync logs with instrument PC
################################################################################
if [ ! -z $MY_USER ]
then
  printf "%0.s~" {1..80}
  echo ""
  echo "~ Syncing logs with instrument PC..."
  printf "%0.s~" {1..80}
  echo ""


  rsync -avP --exclude '*.sh' --protocol=30 $CURPATH/* $MY_USER@$MY_IP:$MY_PATH

  echo ""
fi
################################################################################



################################################################################
# Upload entries to InfluxDB
################################################################################
printf "%0.s~" {1..80}
echo ""
echo "~ Upload entry to InfluxDB..."
printf "%0.s~" {1..80}
echo ""

curl -i -XPOST 'http://localhost:8086/write?db='$MY_DB --data-binary @$MON_PATH/$INSTRUMENT/$YEAR_/$INSTRUMENT"_"$YEAR_$MONTH_"00_000000.log"

echo ""
################################################################################



################################################################################
# Done!
################################################################################
printf "%0.s~" {1..80}
echo ""
echo "~ Done! Your entry was logged successfully."
printf "%0.s~" {1..80}
echo ""

exit 0
################################################################################
