# Power Cycling the Radar

The following steps can be used to completely shut down the radar:

1. [Stop the radar software.](Stopping%20the%20radar.md)
1. Switch off all of the radar transceiver boxes and the timing box from the front panels.
1. Switch off the radar server with the command: `sudo poweroff now`.

To switch the radar on again, follow these steps:

1. Switch the radar server on again at the power button. Wait for the server to boot up.
1. Switch on the timing box and then all of the transceiver boxes. Only switch on one transceiver box at a time for the same PDU, since switching all of them on at the same time will require a sudden surge of current to be supplied.
1. [Start the radar software.](Starting%20the%20radar.md)