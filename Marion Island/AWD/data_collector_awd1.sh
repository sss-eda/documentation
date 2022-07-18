#!/bin/bash

# <About>
#_______________________________________________________________________________
# Copyright © 2019 SANSA. All rights reserved.
#
# DESCRIPTION:
#   This bash script is used to collect real time data from an instrument PC and
#   post it to an InfluxDB database.
#
# NOTES:
#   * This script is called by a process in the Crontab of the data server.
#   * This script calls a data crawler script on the instrument PC, which
#     converts the data to InfluxDB Line Protocol format.
#   * This script then copies the processed data and posts the entries to the
#     local InfluxDB database.
#
# VERSION HISTORY
#   2020/04/27 : Stephanus Schoeman :
#                First implementation of data collector script for MARLEM1.
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

INSTRUMENT="lem1"

myINSTRUMENT="Magnetometer"
myUSER="nerd"
myIP="172.18.30.102"
myDB=MARLEM1db
myCRAWLER="/home/nerd/data_crawler/"

echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo "-> Settings for "$myINSTRUMENT":"
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo "  * USER:          "$myUSER
echo "  * IP:            "$myIP
echo "  * DATABASE:      "$myDB
echo "  * DATA_CRAWLER:  "$myCRAWLER
echo ""
################################################################################



################################################################################
# Execute data crawler on instrument PC
################################################################################
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo "-> Running the data crawler script on the instrument PC..."
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

ssh $myUSER@$myIP "mkdir -p "$myCRAWLER"/logs && "$myCRAWLER/$INSTRUMENT"_data_crawler.sh > "$myCRAWLER/logs/$INSTRUMENT"_data_crawler.log"
echo ""
################################################################################



################################################################################
# Copy the data file from the instrument PC to the server
################################################################################
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo "-> Retrieving the Line Protocol data file from the instrument PC..."
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

rsync -av --remove-source-files $myUSER@$myIP:$myCRAWLER/.$INSTRUMENT"_data.txt" $THISPATH/
echo ""
################################################################################



################################################################################
# Write the data from the data file into the InfluxDB database
################################################################################
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo "-> Writing data to the InfluxDB database..."
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

curl -i -XPOST "http://localhost:8086/write?db=$myDB" --data-binary @$THISPATH/.$INSTRUMENT"_data.txt"
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