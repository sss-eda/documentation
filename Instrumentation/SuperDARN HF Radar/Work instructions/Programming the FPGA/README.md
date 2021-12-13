# FPGA

If the FPGA is new and empty (it will be flashing all its lights when switched on), you have to program it for the first time via JTAG emulator. If the FPGA is not empty and has been programmed before, the Ethernet connection to the radar server and simple program can be used to re-program the flash of the FPGA.

# Flashing an empty FPGA

To program a new and empty FPGA via JTAG emulator, us a PC with iMPACT installed on it and follow these steps:

1. Open iMPACT 64 bit (Xilinx Design Tools/Lab Tools/iMPACT 64-bit) and close any windows that automatically open.
1. Plug in your USB programming cable
1. In the Flows window on the left panel, double click Boundary Scan
1. In the Output menu click Cable Auto Connect
1. Check that the programming cable is detected by looking in the status bar in the bottom right.
1. Plug the JTAG part of the programming cable into the FPGA board and power up the transceiver box.
1. Click the File menu and choose Initialize Chain (Ctrl +I) OR
    1. If prompted about a config file, say yes.
    1. Browse to and select: /Digital Radar/Transceiver boxes/FPGA/Code/V2\_Test\_Sx.bit
    1. When asked: Do you want to attach flash?; click Yes.
    1. Browse to and select: /Digital Radar/Transceiver boxes/FPGA/Code/test.mcs
    1. Select the right settings:
        - BPI PROM: 28F128J3D
        - Data Width: 16
        - Select RS[1:0]b Pin Address Bits:    NOT USED
    1. Right click on FPGA; then click Program.
    1. Right click on Flash; then click Program. (This step takes quite a while to complete!)
        (If pop-ups come up in steps f and g; click on OK.)
        \end{enumerate}
1. A device will appear and you will be prompted to select a bit file. You can choose the bit file or click cancel/bypass if you just want to programme the PROM.
1. If you selected a bit file you can choose NO, when asked if you want to add an SPI or PROM.
1. Click OK to close the next pop-up window.
1. Now you can double click on Program in the Process Window or right-click on the device and choose Program
1. If you chose to bypass the bit file then you need to add a PROM
1. Right-click on the device and choose Add SPI/BPI Flash...
1. Select your MCS file and then choose the settings as shown in the Figure below and then press OKAY.
1. Right  click on the FLASH device and choose Program.
1. The process will take several minutes to complete. Don’t worry if it gives you a CPI warning.

### Re-flashing a FPGA
To re-flash a FPGA that has been flashed with a version of the software before, follow these steps:

1. Connect the transceiver box with the faulty FPGA to the servicing station, making sure that the control network cable is plugged into the switch.
1. NOTE: Avoid re-flashing all of the FPGA's installed in the radar hut.
1. Navigate to the directory: \textit{/home/radar/T3/nflash} on the radar servicing station.
1. Run the command: \textbf{./fpgaflash all}.