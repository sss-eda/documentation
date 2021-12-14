---
title: Deleting an activity
---

# How to delete a maintenance activity
To delete a faulty activity entry, run the script: `del.sh` and follow the instructions, as demonstrated by the following steps:

1. First, the script will display an enumerated list of all the registered systems. It will then prompt for an instrument number, corresponding to the instrument on which the activity is to be logged. Enter the number and then press the `Enter` key.
    ```
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    ~ Please select one of the following instruments:
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    1       SuperDARN Radar
    2       Ozone Radiometer
    3       DemoGRAPE Septentrio PolaRxS
    4       DemoGRAPE 4tuNe SDR
    5       NovAtel GNSS
    6       Dual Frequency GNSS
    7       HartRAO GB1000 GNSS
    8       Automatic Whistler Detector
    9       DVRAS VLF Receiver
    10      World Wide Lightning Location Network
    11      UltraMSK
    12      Fluxgate Magnetometer
    13      Overhauser Magnetometer
    14      Rock Magnetometer
    15      DTU Magnetometer
    16      Pulsation Magnetometer
    17      Imaging Riometer
    18      Wide-Angle Riometer

    -> Instrument number: █
    ```

1. When asked for the date, once again a default value is displayed. The default date is that of the present day and if the event occurred on a previous day, that date should be entered in the correct format.
    ```
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    ~ Please enter the date of the event:
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    -> Date (DEFAULT 1970-01-01) : █
    ```

1. The script will then display an enumerated list of all the activities logged for the date previously specified. Enter the number corresponding to the faulty entry and press `Entry` to delete that entry. Wait for the logs to be synchronized with the instrument PC and influxDB database.
    ```
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    ~ Please choose the activity you want to remove from the list below:
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    --------------------------------------------------------------------------------
    Index   Time    Person          Status          Description
    --------------------------------------------------------------------------------
    1       01:02   Anonymous       off             For demonstration purposes only.
    2       03:04   Anonymous       on              For demonstration purposes only.
    --------------------------------------------------------------------------------

    -> Index of activity to be removed : █
    ```