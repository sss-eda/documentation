#<About>
#_______________________________________________________________________________
# Copyright © 2024 SANSA. All rights reserved.
#
# DESCRIPTION:
#   This basic Python script provides a test to read data from USB-to-Serial ports.
#
# NOTES:
#   * This script needs to be called manually as it's only for testing.
#   * First install 'pySerial' library in Python on the RaspberryPi.
#   * This library will read the data from a serial port on the RPi.
#
# VERSIONS:
#   * Frist implementation: DJ van Wyk (2024)
#_______________________________________________________________________________
# </About>


import serial
import os
from datetime import datetime

# Define the serial port and baud rate
serial_port = '/dev/ttyUSB0'  # Change this to match your serial port
baud_rate = 11500

# Define function to create the data files and schedule it
def create_new_file():
    current_date = datetime.now().strftime("%Y-%m-%d")
    filename = f"MARLEM111_{current_date}.dat"
    return open(filename, "w")

# Open the serial port
ser = serial.Serial(serial_port, baud_rate)

current_file = create_new_file()
# Tracking current date with a variable
current_date = datetime.now().date()

try:
    # Read and print data from the serial port
    while True:
        # Read a line from the serial port
        line = ser.readline().decode().strip()
        #print(line)

        # Check if the date has changed
        if datetime.now().date() != current_date:
            current_file.close()
            current_file = create_new_file()
            current_date = datetime.now().date()

        current_file.write(line + '\n')
        current_file.flush()

except KeyboardInterrupt:
    # Handle Ctrl+C gracefully
    print("Exiting...")
finally:
    # Close the serial port
    ser.close()
    current_file.close()