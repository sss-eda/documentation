#!/bin/bash

# <About>
#_______________________________________________________________________________
# Copyright © 2019 SANSA. All rights reserved.
#
# DESCRIPTION:
#   This bash script is used to collect real time status from an instrument PC
#   and post it to an InfluxDB database.
#
# NOTES:
#   * This script is called by a process in the Crontab of the data server.
#   * This script calls a status crawler script on the instrument PC, which
#     converts the status data to InfluxDB Line Protocol format.
#   * This script then copies the processed data and posts the entries to the
#     local InfluxDB database.
#
# VERSION HISTORY
#   2019/01/27 : Stephanus Schoeman :
#                First implementation of status collector script for SANRKM1.
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

INSTRUMENT="rkm1"
INFO=$INSTRUMENT".json"

myINSTRUMENT=$(sed -n 's/^\s*"instrument"\s*:\s*"\(.*\)".*$/\1/p' $INFO)
myUSER=$(sed -n 's/^\s*"user"\s*:\s*"\(.*\)".*$/\1/p' $INFO)
myIP=$(sed -n 's/^\s*"ip"\s*:\s*"\(.*\)".*$/\1/p' $INFO)
myDB=$(sed -n 's/^\s*"database"\s*:\s*"\(.*\)".*$/\1/p' $INFO)
myCRAWLER=$(sed -n 's/^\s*"datacrawler"\s*:\s*"\(.*\)".*$/\1/p' $INFO)

echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo "-> Settings for "$myINSTRUMENT":"
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo "  * USER:           "$myUSER
echo "  * IP:             "$myIP
echo "  * DATABASE:       "$myDB
echo "  * STATUS_CRAWLER: "$myCRAWLER
echo ""
################################################################################



################################################################################
# Execute data crawler on instrument PC, fetch data and upload to InfluxDB
################################################################################
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo "-> Running the data crawler script on the instrument PC..."
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ssh $myUSER@$myIP "mkdir -p "$myCRAWLER"/logs && "$myCRAWLER/$INSTRUMENT"_status_crawler.sh > "$myCRAWLER/logs/$INSTRUMENT"_status_crawler.log"
echo ""

echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo "-> Retrieving the Line Protocol data file from the instrument PC..."
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
rsync -avL --protocol=30 --remove-source-files $myUSER@$myIP:$myCRAWLER/.$INSTRUMENT"_status.txt" $THISPATH/
echo ""

echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo "-> Writing data to the InfluxDB database..."
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
curl -i -XPOST "http://localhost:8086/write?db=$myDB" --data-binary @$THISPATH/.$INSTRUMENT"_status.txt"

rm $THISPATH/.$INSTRUMENT"_status.txt"
################################################################################



################################################################################
# Script completed successfully.
################################################################################
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo "Done!"
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

exit 0
################################################################################