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
#   * Added file handling: Nivek Ghazi (2024)
#_______________________________________________________________________________
# </About>
# set the raspbery pi time to UT - to use this time to generate daily file names

import serial
import datetime 
import schedule

# Define the serial port and baud rate
serial_port = '/dev/ttyUSB0'  # Change this to match your serial port
baud_rate = 115200

def create_file():
    global f
    f.close()
    outfname='MAROVH1'+datetime.datetime.now().strftime('-%y%m%d')
    #outfname='MAROVH1'+datetime.datetime.now().strftime('%d-%m-%Y-%H-%M-%S')
    f=open(outfname,"a+")


# Schedule the file creation every day at 00:00:00
schedule.every().day.at("00:00:00").do(create_file) #run the schedule to create a new file at 00:00:00 everyday
# schedule.every(10).minutes.do(create_file)  #run the schedule to create a new file every 20 minutes

# Open the serial port
ser = serial.Serial(serial_port, baud_rate)
# create the first day file
outfname='MAROVH1'+datetime.datetime.now().strftime('-%y%m%d')
#outfname='MAROVH1'+datetime.datetime.now().strftime('%d-%m-%Y-%H-%M-%S')
f=open(outfname,"a+")

try:
    # Read and print data from the serial port
    while True:
        # Read a line from the serial port
        # line = datetime.datetime.now().strftime('%d-%m-%Y %H:%M:%S') +', '+ ser.readline().decode().strip()
        schedule.run_pending()
        line =ser.readline().decode().strip()
        print(line)
        f.write('%20s\n'% (line))

except KeyboardInterrupt:
    # Handle Ctrl+C gracefully
    print("Exiting...")
finally:
    # Close the serial port
    ser.close()
    f.close()