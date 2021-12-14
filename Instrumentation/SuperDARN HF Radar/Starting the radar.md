# Starting the Radar Software

To start the radar properly, follow these steps:

1. Navigate to the directory: `/home/radar/T3/cpart/`.
1. To test the operation of the radar, run this command: `./sop`.
1. Choose 1 to select the transmit test.
1. Choose 3 to start transmitting.
1. Verify on the transceiver boxes that they all have antenna voltages in the range of 300V - 500V and that their sequence counts are increasing.
1. Choose 5 to stop the test.
1. Press ctrl-c to exit the test program.
1. Run `./sop` again to reset the tansceiver boxes' sequence counts.
1. Press ctrl-c again.
1. Ping each of the radar boxes to ensure that their front panels are all functional.
1. Open a screen session with the command: `screen`, or enter an existing screen session with: `screen -x`.
1. Run the command: `start.radar` in the screen session.
1. Exit the screen session using: `ctrl-a` and then `d` if the radar server is being accessed remotely.
1. Log the activity on using the logging script.
1. Wait until all of the beams have been scanned at least twice, since the software often stops with the error: "No pending program." during the first scan.