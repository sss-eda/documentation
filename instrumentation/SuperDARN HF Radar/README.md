> This document should serve as an overview of this domain, as well as the hub document to the rest of the documents inside of the domain. It shouldn't be specific to any site, but only to this instrument type.

# Introduction
This manual serves as a comprehensive guide to maintaining the SuperDARN high frequency radar at SANAE IV. This section of the manual provides a concise background on the SuperDARN Radar, how it works and what it looks for.

## Infrastructure Overview
The infrastructure of the radar and the maintenance thereof are discussed in depth [here](2_infrastructure.md). The radar's infrastructure consist of 20 antenna masts and a hut which houses all of the radar's transceiver and server equipment, as well as the network and electricity connection to the base infrastructure.

The radar hut is located about 600m South-East of the base at the center of the main antenna array, as shown in [figure 1](#figure-1-map-of-sanae-iv-science-area). There is a lifeline stretching from the base to the radar hut, as indicated on the map in [figure 1](#figure-1-map-of-sanae-iv-science-area).

###### Figure 1. Map of SANAE IV science area.
![Map of SANAE IV science area](images/introduction/map.bmp)

Electricity is relayed from the base to the radar hut, from where it is also distributed to the small satellite dome where the ozone radiometer is located. The power is not connected to the base UPS's, so the radar has its own small UPS. For more information on the radar hut, refer to [this](2_infrastructure.md#radar-hut).

There is 20 antenna masts forming part of the radar infrastructure on which the antennas are mounted. See [here](#infrastructure.md#masts) for more details on the maintenance and climbing of these masts.

## Hardware Overview
The hardware of the radar and the maintenance thereof is discussed in depth in [this document](3_hardware.md). The radar has a main antenna array consisting of 16 antennas and a secondary array with 4 antennas. Each of these antennas is driven by a transceiver box, interconnected by the radar's server network.

The antennas are hexagonal and consist of two halves, as shown in [figure 2](#figure-2-a-radar-antenna) below. \subsecref{hw_antennas} provides more details on the construction and maintenance of the antennas.

###### Figure 2. A radar antenna.
![A radar antenna](images/introduction/antenna.jpg)

[This section](hardware.md#transceiver-boxes) provides step-for-step instructions on the servicing and maintenance of the radar's transceiver boxes. \figref{intro_box} shows the basic layout for the front and back of a radar transceiver box.

The configuration of the server and network setup is demonstrated in the diagram shown in \figref{intro_hw}. The local radar network consists of a timing, control and monitoring network. The server is also connected to the base's science network and thus also the internet. More details concerning the maintenance of the server network can be found in \subsecref{hw_network}.

###### Figure 3. Radar transceiver box layout.
![Radar transceiver box layout](images/introduction/box_diagram.jpg)

###### Figure 4. Network layout of the radar hardware.
![Network layout of the radar hardware](images/introduction/layout.pdf)

## Software Overview
The radar's various software components are discussed in depth in [Software](4_software.md). The radar has several components that requires their own specialized software:
- RST - Radar control software installed on the radar server
- VHDL code installed on the T3 FPGA Board
- C Code installed on the Front Panel processor
- VHDL code installed on the HPSW FPGA

The RST software is mostly written in C and was developed to produce a standard data product for all SuperDARN radars. All of the source code is available, but rarely gets updated or changed. See \subsecref{sw_rst} for more information.

The VHDL source code for the T3 FPGA board isn't fully available, but is currently being adapted to allow for operation of the secondary array too. The file for reprogramming the board is available, should one of them start giving problems. See \subsecref{sw_fpga} for more details.

C code for the Front Panel's Zilog processor is available and will need to be updated from time to time. This code is responsible for monitoring the state of each transceiver box: On the Front Panel LCD as well as remotely via the server's monitoring network. Refer to [this section](4_software.md#front-panel) for more details.

The high power switches have a small CPLD installed on them for monitoring, control and communication purposes. The VHDL code for these chips are available, but shouldn't require any changes. Should one of the boards give problems, they can be reprogrammed. Refer to \subsecref{sw_hpsw} for more details.

## Standard Operating Procedures Overview
[Operations](5_operations.md) gives detailed information about the standard operating procedure for the radar. This includes instructions for daily checks to be performed, operating the radar, monitoring the radar's performance and generating monthly reports.

\subsecref{ops_summary}, \subsecref{ops_dailychecks} and \subsecref{ops_procedures} provide all of the information necessary for the radar's everyday operations.

\subsecref{ops_monitoring} provides details on the remote monitoring system implemented for all of the instruments. The Grafana monitoring software works on an influxDB back-end.

\subsecref{ops_reporting} gives instructions and information on the automatic reporting software used to generate a skeleton for each monthly report.

# Infrastructure

## Overview
The infrastructure of the radar and the maintenance thereof are discussed in depth [here](2_infrastructure.md). The radar's infrastructure consist of 20 antenna masts and a hut which houses all of the radar's transceiver and server equipment, as well as the network and electricity connection to the base infrastructure.

The radar hut is located about 600m South-East of the base at the center of the main antenna array, as shown in [figure 1](#figure-1-map-of-sanae-iv-science-area). There is a lifeline stretching from the base to the radar hut, as indicated on the map in [figure 1](#figure-1-map-of-sanae-iv-science-area).

The static infrastructure of the radar consists mainly of the radar hut and the 20 antenna masts with their stay ropes.

The radar hut contains emergency supplies, climbing gear, tools, various spare parts for the radar and has electricity relayed to it from the base.

Each antenna mast has eight stay ropes that keeps it upright. These ropes break from time to time and then needs to be repaired or replaced.

## Radar Hut
This section provides instructions for the maintenance of the radar hut and inventory lists of its contents.

The radar hut consists of two compartments: The lobby and the radar room, separated by a door. The lobby contains most of the supplies, while the radar room contains the radar hardware and a cabinet of some smaller spare components, stationary and miscellaneous items.

### Emergency Supplies
The radar hut is located about 600m from the base. This means that one can get stuck there if the weather changes abruptly and becomes unfavorable for traveling back to the base. Thus, the hut is stocked with emergency supplies for this eventuality. Supplies for medical emergencies are also necessary since the base is so far away.

It is the responsibility of the overwintering radar engineer to see that these supplies are always up to standard and not expired. See \tabref{infra_supplies} below for a comprehensive list of all supplies that need to be in the radar hut at all times:

###### Table 1. Radar hut emergency supplies - Food.
| Item | Description | Details |
| ---- | ----------- | ------- |
| Water | There is a dispenser in the hut. It needs to be cleaned and refilled regularly. | 20 Liters |  
| Canned food | A variety is preferable. Preferably instant meal type of things. Check expiry dates. | 10 cans |
| Instant soup | A variety is preferable. Check expiry dates. | 10 packs |
| Biscuits | Provitas, rusks, crackers, etc. Check expiry dates. | 4 packs |
| Fruit bars | A variety is preferable. Check expiry dates. | 1 box |
| Dried fruit | A variety is preferable. Check expiry dates. | 2 packs |
| Coffee | Instant coffee powder Check expiry date. | 500g |
| Tea | Preferably Rooibos and English. Check expiry date. | 20 bags |
| Condensed milk | Sweetened. Check expiry dates. | 3 cans |
| Game | Energy drink for restoring electrolytes. Check expiry dates. | 1 Can |
	
###### Table 2. Radar hut emergency supplies - Utensils.
| Item | Description | Details |
| ---- | ----------- | ------- |
| Electric kettle | Check that it's in a working condition. | 1 |
| Small electric stove | Check that it's in a working condition. | 1 |
| Plate | Check condition. | 1 |
| Cup | Check condition. | 1 |
| Other | Knife, fork, spoon, etc. | 1 set |

###### Table 3. Radar hut emergency supplies - Bedding.
| Item | Description | Details |
| ---- | ----------- | ------- |
| Mattress | Folded mattress. | 1 |
| Sleeping bag | Clean before takeover. | 1 |
| Pillow | New covers before takeover. | 2 |

###### Table 4. Radar hut emergency supplies - Medical.
| Item | Description | Details |
| ---- | ----------- | ------- |
| Medical aid kit | Give to doctor for restocking before takeover | 1 |
| Sun screen | Check quantities an expiry dates. | 2 tubes |
| Hand warmers | Unopened. Check expiry dates. | 4 pairs |

Furthermore, the fire extinguisher should also be checked on a regular basis. Make sure that the extinguisher is refilled during takeover when the DPW is servicing the rest of the fire extinguishers on base.

### Climbing Gear
Climbing gear for antenna maintenance is kept in the radar hut as well. This gear should be inspected on a regular basis according to standards provided during the working at heights training in Cape Town.

It is the responsibility of the overwintering radar engineer to ensure that the climbing gear is always ready to go and well maintained. See \tabref{infra_gear} for a list of all equipment that needs to be available.

###### Table 5. Radar Hut climbing gear - Rescue bag.
| Item | Description | Details |
| ---- | ----------- | ------- |
| Rescue bag | Smaller red tarp bag. | 1 |
| Dynamic climbing rope | Properly coiled in the red bag. | 1 |
| Ratchet or jag system | Make sure they're in a working condition. | 1 |
| Descender | - | 1 |
| Temporary slings | - | 2 |
| Carabiners | Attached to the slings | 4 |

###### Table 6. Radar Hut climbing gear - 2 Climbing sets.
| Item | Description | Details |
| ---- | ----------- | ------- |
| Helmet | Check that their in good condition. | 1 per set |
| Full harness | Inspect regularly. | 1 per set |
| Work belt | (Or 2 cow tails) Check condition. | 1 per set |
| Shock absorbing lanyard | Check condition. Use carabiners instead of hooks to prevent slipping off of ladder rungs. | 1 per set |
| Carabiners | For any other gear/equipment needed. | 4 per set |

###### Table 7. Radar Hut climbing gear - Other.
| Item | Description | Details |
| ---- | ----------- | ------- |
| Big red bag | Contains climbing sets and spares. | 1 |
| Climbing hooks | Not used, but could come in handy. | 4 |
| Descenders | Various types. | 4 |
| Ratchet | Spare for rescue set. | 1 |
| Shock absorbing lanyards | Various types and lengths. | 4 |
| Slings | Various lengths | 4 |
| Adjustable work belt | - | 1 |
| Carabiners | Spares | 5 |
| Jag system | Spare for rescue set. | 1 |
| Climbing sling | - | 1 |
| Helmet | Spare | 1 |

Otherwise, there are also a whole pile of old ropes removed from the radar that can be used as go-ropes. Be sure to take one with for climbing, this makes help from the ground much easier.

\figref{infra_rescue} shows what a rescue set should look like and what it should include.

###### Figure 1. A rescue set and its content.
| Rescue bag | Contents |
| - | - |
| ![A rescue set and its content.](images/infrastructure/rescue.jpg) | ![A rescue set and its content.](images/infrastructure/rescue_content.jpg) |

\figref{infra_climbing} shows what the climbing gear bag should look like and what it should include.

###### Figure 2. A climbing set and its content.
| Rescue bag | Contents |
| - | - |
| ![A rescue set and its content.](images/infrastructure/climbing.jpg) | ![A rescue set and its content.](images/infrastructure/climbing_content.jpg) |

\figref{infra_set} shows what a climbing set should look like and what it should include. There are hooks in the radar hut where these can be hung to make it quicker to get ready for climbing.

##### Figure 3. Gear a climbing set should include.
![Gear a climbing set should include.](images/infrastructure/set.jpg)

### Tools and Supplies
Any tools or materials necessary for routine maintenance on the radar should be available in the radar hut. If something breaks or is not available in the hut anymore, it should be added to the procurement list for the following takeover. \tabref{infra_tools} shows a list of the aforementioned tools.

###### Table 8. Radar Hut Tool List - Tools.
| Item | Description | Details |
| ---- | ----------- | ------- |
| Tool bag | Complete tool set. | 1 |
| Spanner sets | Two complete sets, imperial and metric. (Blue bag) | 2 |
| Big spanners | Two complete sets of large spanners, imperial and metric. (Against wall) | 2 |
| Metal strapping tool | For fastening metal straps. | 1 |
| Metal strapping | For tying the cable to the radar masts. See that there's enough. | 1 roll |
| Metal strapping sliders | For use with the metal straps. See that there's enough. | 1 box |

###### Table 9. Radar Hut Tool List - Cleaning Supplies.
| Item | Description | Details |
| ---- | ----------- | ------- |
| Bucket | For cleaning. | 1 |
| Cloths | One for cleaning and one for dishes. | 2 |
| Mr Min | For cleaning and wood cabinet. | 1 |
| Dish Soap | For cleaning dishes. | 1 |
| Brush | For cleaning. | 1 |
| Broom | For sweeping every now and again. | 1 |

###### Table 10. Radar Hut Tool List - Outside.
| Item | Description | Details |
| ---- | ----------- | ------- |
| Spade | For clearing snow. | 1 |
| Pry bar | For clearing hard ice. | 1 |

### Electricity
Electricity to the radar hut is supplied by the base. From there, it is also relayed to the Ozone Radiometer dome.

The power supplied to the radar is not on the base's UPS. There is a small UPS in the radar hut, however (see \figref{infra_ups}). This UPS only lasts about 5 minutes, just enough to properly switch off the radar. That means that the radar should be switched off as quickly as possible whenever the base looses power.

##### Figure 4. Small UPS located in the radar hut's lobby.
![Small UPS located in the radar hut's lobby.](images/infrastructure/ups.jpg)

The distribution board is located in the radar hut, but shouldn't be tampered with by anyone other than the base electrical engineer or a certified electrician.

### Radar Parts
Spare parts for the radar that should be kept in the radar hut include the following:
- Spare rope for stay ropes and antennas.
- Thin coaxial cable the antennas are made of.
- Coaxial antenna cable that connects the antennas to the radar hut.
- A set of at least 4 spare antenna halves.
- Any other components needed to make more antenna halves.

Spare parts for the transceiver boxes can be kept in the radar hut if the servicing station was moved there for the winter, however they should be in the base if that is where radar boxes are being serviced.

## Radar Masts
The radar consists of two two antenna arrays: The main and secondary arrays. You can see both of them in \figref{infra_radar} below.

##### Figure 5. The main and secondary arrays of the radar.
![The main and secondary arrays of the radar.](images/infrastructure/radar.jpg)

### Main Array
The 16 masts supporting the main antenna array are held up by stay ropes. These ropes need to be maintained at all times. The masts in the main array are equipped with rungs for climbing to do repairs.

Whenever maintenance is being done, proper procedure should be followed. Refer to the SANSA fall protection plan for more details. Training for working at heights is mandatory and at least two trained persons must be present when maintenance is being done. At least one qualified person should be geared up and on the ground while anyone is climbing, in case it is necessary to perform a rescue.

### Secondary Array
The 13 masts supporting the 4 secondary array antennas are held up by stay ropes. These also need to be maintained at all times. These masts are not equipped with rungs for climbing, so any repairs to these have to be done with the help of a crane CAT and cherry picker basket.

Proper safety procedures for this have to be followed too. They are similar to that for climbing, so refer to the fall protection plan again for more details.

Please note that the secondary array antennas are not currently installed, but that the masts and stay ropes need to be maintained in any case to prevent any damage to the infrastructure.

# Hardware

This section provides instructions for maintaining all of the SuperDARN Radar's hardware. This includes the transceiver boxes, antennas and the server network.

## Antennas
The radar has 20 antennas altogether; 16 in the main array and 4 as part of the secondary array. Each antenna consists of two halves which, put together, makes a hexagon. It is the responsibility of the radar engineer to ensure that the antennas are always in good shape.

### Making antenna halves
For making new antenna halves, use an existing example as reference. Some of the parts will also need to be scavenged from the broken element being replaced. [Figure 1](#figure-1-antenna-element-measurements) below shows the dimensions for the antenna element itself.

###### Figure 1 . Antenna element measurements.
![Antenna element measurements.](images/hardware/element.jpg)

It is recommended that at least four already made antenna halves be kept in the radar hut. That way, spares can be made during takeover and simply replaced if any elements brake throughout the year.

### Measuring cable loss
To test an antenna, the cable loss can be measured for each antenna from within the radar hut. To do this, the mobile antenna analyzer can be used. These values should be recorded and entered into the month-end reports.

The antenna analyzer is usually kept in the radar hut for convenience. Measurements should be made at least every second month to ensure that all antennas are still in good condition. To make a cable loss measurement:
1. Plug in the analyzer's power supply.
1. Disconnect the antenna cable from the transceiver box.
1. Connect the antenna cable to the port on the analyzer.
1. Read and record the value shown for the range between 12.5 MHz and 14.5 MHz.
1. Reconnect the antenna cable to the transceiver box.

There are several other measurements that can also be made with the analyzer, but none of which will provide any useful information for regular maintenance checks. However, they might be useful for fault finding with the antenna baluns or load connections.

## Transceiver Boxes

This section provides a guide for changing settings, servicing and troubleshooting a T3 radar transceiver box. The transceiver box should be laid out and wired according to diagram in [figure 2](#figure-2-t3-transceiver-box-diagram).

Inspect the box and make sure that each PCB is in the correct position and that all wires are in place. Check the green Phoenix connectors for any loose wires and tighten the screws if necessary. Check that the boards are mounted properly to the aluminium plate, especially the power amplifier and tighten the screws, if necessary. Check that there is no loose debris inside the box e.g. small pieces of solder wire, which can cause a short.

###### Figure 2. T3 Transceiver box diagram.
![T3 Transceiver box diagram.](images/hardware/box_diagram.jpg)

### Equipment Setup

You will require the following equipment for setting up and testing the transceiver boxes:
* 4-Channel Tektronix Scope (TDS 3054C).
* Tektronix current sensor module and current probe (TCPA300 + TCP312).
* Agilent 4-Channel Scope (MSO6104A)
* Radar Lab 2.0
* AWG (33250A)
* High voltage scope probe
* DMM
* 50 Ω dummy load
* Bench power supply (60V, 10A)
* SMA 50 Ω terminator

### Preparing a Transceiver Box

1. Starting on the bottom side, remove all the green Phoenix connectors from their headers.
1. Remove the chassis fan connector (P7) from the Power Distribution Board.
1.  Remove the ribbon cables (P2, P3 and P5) from the Front Panel.

###### Figure 3. Preparing the transceiver box.
![Preparing the transceiver box.](images/hardware/box_prep.jpg)

### 50V Power Supply

1. The C13 mains connector on the back of the box requires a 3.15A slow blow fuse. Check that the fuse is inserted and intact.
1. Insert the AC mains power cord on the 50V PSU and switch it on. Use a DMM to check that the output voltage is 50V ±0.5V. If the voltage is out of tolerance then use a small screwdriver to adjust the small potentiometer (Vadj) on the back of the PSU itself.
1. Power down.

###### Figure 4. Testing the 50V power supply.
![Testing the 50V power supply.](images/hardware/box_50v.jpg)

### DC Supply

1. Connect J1 on the DC Supply Board (50V). Make sure J2 and J3 are also connected to the switch on the front plate and that the switch is in the `OFF` position. Leave all other connections for now. Switch the mains power on again.
1. Check D11 and D12. They should both be `OFF`. Now toggle the switch on the front plate.
1. Check that D12 lights `ON`. and that D11 stays `OFF`.
1. If D2 does not light up, pull the connector J2. If it then lights up, there is a problem with the switch; check that the wires are secure in the switch connector and/or check the switch by doing a continuity test. Check that there is nothing connected to the DC Supply Board that could be pulling current, there may be a short circuit causing the module to shut-down.
1. If that still does not solve the problem, the module has likely failed and should be replaced.
1. If D2 lights ON, then the relay has probably failed and should be replaced.
1. Finally check the output voltage on the 15V line of J4. It should be about 16.2V at no load. This is to compensate for the voltage drop in the thermistor, which is connected in series with the 15V line between J4 on the DC Supply Board and J6 on the Power Distribution Board. Check that the thermistor is working by measuring the 15V line on the Power Distribution Board side of the thermistor. At no load it should show that same voltage as measured earlier, about 16.2V.
1. Disconnect the white wire (50_en) from the Phoenix connector at J6 on the Power Distribution Board. Use the desktop power supply to apply exactly 3.3V to this wire. This will toggle the relay and light up D2. If this does not work, there is likely a problem with the relay and it should be replaced. Verify by measuring the voltage on the 50V line of J4 on the DC Supply Board. Replace 50_en back into J6.
1. Switch off the 15V on the front plate and the mains power too.

###### Figure 5. Testing the 15V DC-DC supply board.
![Testing the 15V DC-DC supply board.](images/hardware/box_dc.jpg)

### Power Distribution

1. Insert the Phoenix connector into J6 on the Power Distribution Board. Insert the Special Test Cable (STC) into P2. Leave all other connections on the Power Distribution Board disconnected for now.
1. For reference the pins required on the STC are:
    * Pin 1 – Ground
	* Pin 19 and 20 TxRx (switching signal for PA and HPSW)
	* Pin 18 and 16 – 3.3V (50V enable, HV enable)
	* Pin 3 – Ground
1. Switch on the mains power and then switch on the 15V power.
1. Check D1 and D2 again on the DC Supply Board. If D1 does not light up or if D1 flashes then there is a fault on the Power Distribution Board. If this is the case, check that the thermistor is working as the inrush current to the capacitors C9 and C10 will trip the 15V supply if it is not limited by the thermistor. Otherwise you will have to fault find on the Power Distribution Board. The IC U2 and the 5V module are possible failure points as well as the regulators U1 and U3.
1. If all goes well, D1, D2 and D3 on the Power Distribution Board should light up as well as D8.
1. If D1 is off, check the 3.3V regulator U1; if D2 is off, check the 5V DC-DC converter; if D3 is off, the 15V line is faulty, so use the previous steps to debug. D8 is the fan controller, check U3.
1. Measure voltages on P1, P3 and P8 (3.3V, 5V and 15V) using a DMM. 3.3V±0.1V; 5V±0.2V and 14.6V is nominal.
1. Use 3.3V from the desktop power supply to turn on the relay via the STC and test the 50V on P9 (D4 should also light up when you do this).
1. Switch off the 15V from the front switch, plug in the fan on header P7, and switch on again. The fan should start up. Adjust potentiometer R35 to control the fan speed. If the fan does not start up, you likely have an inrush current problem or U3 is faulty.
1. If all is well, switch off from the front switch and move on to step 5.

###### Figure 6. Testing the power distribution board.
![Testing the power distribution board.](images/hardware/box_distro.jpg)

### Front Panel

1. Connect the ribbon cable P2 on the Front Panel to the Power Distribution Board. Power on.
1. There are three LED’s on the Front Panel, indicating voltages 15V, 5V and 3.3V. If one of the LED’s is off check the 5V or 3.3V regulators on the Front Panel. The 15V comes from the Power Distribution Board so a fault on the 15V line by now will be caused by the Front Panel Board so fault find there.
1. There is also one row of four LED’s on the front plate which should light up. The second row of LED’s should be off but may flash momentarily at switch on.
1. Scroll using the turn knob to the voltage screen on the Front Panel and check that the voltages are displaying. The voltages from the FPGA will be blank at this time. If any other voltages from the Power Distribution Board are missing then check the ribbon cable. Remember to apply 3.3V to the relay to see the 50V display.
1. Power off.
1. Now connect the remaining ribbon cables P3 and P5. Power up and check for faults. If a fault occurs after this then the problem is either with the Lantronix Board or the FPGA. The likely cause is a damaged ribbon cable, so check that first before continuing to fault find.
1. D1 on the Lantronix board should light up if all is OK.
1. Power off.

###### Figure 7. Testing the front panel board.
![Testing the front panel board.](images/hardware/box_fp.jpg)

### Capacitor Farm

1. Connect the Phoenix connector between the Power Distribution Board (J3) and the Capacitor Board (J1).  Make sure that the discharge resistor is connected at J2 on the Capacitor Board.
1. Power on and apply the 3.3V signal to the STC. When 3.3V is applied the 50V will enable and D3 on the Capacitor Board will light up. Disconnect the 3.3V signal and D3 should start to dim. After approximately 15 to 20 seconds, D3 should be completely off.
1. If the Capacitor Board does not discharge, check the MOSFET, Q2. Also check that the relay has shut off the 50V supply.
1. Check that the Front Panel Board does not brown out and reset. If this happens, there is a problem with C9 and C10, they are not large enough or are not connected properly, check this with a continuity test.

###### Figure 8. Testing the capacitor board.
![Testing the capacitor board.](images/hardware/box_cap.jpg)

### High Power Switch

1. Switch on the AWG and set the frequency to 12.5 MHz and set the amplitude to 500mVp-p. Connect a BNC cable between the Output of the AWG and Channel 1 on the Agilent MSO6104A to view the waveform. Make sure to press ”Output” on the front face to enable the waveform. Remember to set the impedance of the channel to 50$\Omega$. Check that the waveform displayed is correct.
1. Connect the Special Test Cable (STC) to the “Tx/Rx” of the Radar Lab 2.0 via the BNC-connector and insert the other end into P2 of the Power Distribution Board. This will give us manual control over some of the FPGA functions needed for the tuning process.
1. For reference the pins required on the ribbon cable are:
	* Pin 1 – Ground
	* Pin 19 and 20 Tx/Rx (switching signal for PA and HPSW)
	* Pin 18 and 16 – 3.3V (50V enable, HV enable)
	* Pin 3 – Ground
1. Terminate the output at the antenna port with the 100W dummy load.
1. Make sure that the Phoenix connector J2 is removed from the HPSW. Replace it with a connection to the bench PSU. Set the PSU to 30V and limit the current to 1A.
1. Switch on the power of the transceiver box, the Radar Lab 2.0; as well as the 30V from the PSU to the HPSW.
1. Check that the Tx/Rx pulses are coming through on P5.
1. Check the TP_A is a replica of the Tx/Rx signal. If there is no waveform on TP_A, check that the CPLD is programmed. Otherwise, there is possibly a fault with the CPLD or its clock.
1. Check that P6 switch waveform goes from a DC off-set of about half of the 15V supply (7.5V) up to the HV supply voltage, which in this instance is set to 30V.
1. Power off.
1. Replace the 30V with the 1000V (reconnect the phoenix connector from the HV supply board). Switch on and check that P6 is now the switched 1000V.
1. Power off and return to 30V supply.
	###### Figure 9. First HPSW oscilloscope measurements.
	| ![Signal 1](images/hardware/signal_1.jpg) | ![Signal 2](images/hardware/signal_2.jpg) |
	| - | - |
	| ![Signal 3](images/hardware/signal_3.jpg) | ![Signal 4](images/hardware/signal_4.jpg) |
	| ![Signal 5](images/hardware/signal_5.jpg) | ![Signal 6](images/hardware/signal_6.jpg) |
	| ![Signal 7](images/hardware/signal_7.jpg) | ![Signal 8](images/hardware/signal_8.jpg) |
1. Remove the dummy load and connect the RF signal to the antenna port (12.5 MHz frequency and 0 dBm amplitude).
1. Make sure that you terminate the input port from the power amp or leave it connected to the power amp.
1. Power on.
1. Check that the signal from the antenna can be seen at the receive port, when the Tx/Rx switches low. You can also check that there is no leakage into the input port by terminating the receiver port and measuring on the input.
    ###### Figure 10. Second HPSW oscilloscope measurements.
    | ![Signal 9](images/hardware/signal_9.jpg) | ![Signal 10](images/hardware/signal_10.jpg) |
	| - | - |
1. Power off.
1. Terminate the receiver port.
1. Connect the RF signal to the input.
1. Power on.
1. Measure that the signal is getting through to the antenna port when the Tx/Rx signal is high. Also check that there is no leakage to the receiver by terminating the antenna port and measuring on the receiver port.
    ###### Figure 11. Third HPSW oscilloscope measurements.
    | ![Signal 11](images/hardware/signal_11.jpg) | ![Signal 12](images/hardware/signal_12.jpg) |
	| - | - |

Once you are comfortable with what needs to be terminated when, where and why you can also use this shortcut testing sequence:
1. Make sure that the Phoenix connector J2 is removed from the HPSW. Replace it with a connection to the bench PSU. Set the PSU to 30V and limit the current to 1A.
1. Connect the Rx and PWRAMP RF connectors each to a channel on the oscilloscope (Channel 2 & 3).
1. Remove the dummy load and connect the RF signal to the antenna port (12.5 MHz frequency and 0 dBm amplitude)
1.  Power up the transceiver box mains, then the front panel and then the 30 V PSU supply.
1.  Check the outputs at P5, P6 and TP_A (As described above).
1.  Now switch on the AWG output.
1.  Monitor the Rx and Tx signals on channel 2 & 3; make sure that both the channels are set to a 200mV scale on the oscilloscope and they should have more or less the same pk-pk voltages. If Rx is more than 75 mV less than Tx; the problem is most probably with a faulty limiter (D4). Test it and if needed replace it. Other regular known culprits to be investigated (if it is found not to be the limiter) are Q3 and Q4 mosfets, located at the bottom of the HPSW board.
1.  Switch off the output of the AWG; switch off the 30 V PSU supply; switch off the front panel; and then lastly switch off the transceiver box mains.
1.  Remove the RF signal and connect the dummy load to the antenna port.
1.  Remove the oscilloscope channel connectors from the Rx and PWRAMP RF connectors and plug all the normal RF circuit connections back in.
1.  Replace the 30 V PSU supply with the 1000V (reconnect the phoenix connector from the HV supply board).
1.  Switch on the transceiver box mains; switch on the front panel and then switch on the 3.3 V supply connected to the STC.
1.  Check that P6 is now the switched 1000V (REMEMBER to use the HV oscilloscope probe when measuring voltages fed from the HV Supply!) Switch everything off in reverse order of step 12.

### Power Amplifier

1.  Connect the Tx Env output of the Radar Lab 2.0 to the ‘pulse’ modulation input on the back of the AWG/signal generator(Modulation In) to generate the RF pulses.
1.  Connect the Tx/Rx signal from the Radar Lab to the STC in the FGPA header on the Power Distribution Board.
1.  Connect 3.3V from the bench PSU to the 50V enable and the HV supply enable to the FPGA header on the Power Distribution board (via the STC). – This step should already be done!
1.  Remove the 50V supply leads from the capacitor board and replace with 30V from the bench PSU. Limit the current initially to 1A.
1.  Switch on Radar Lab 2.0
1.  Turn all potentiometers anti-clockwise all the way so that there is no bias on the gates of the MOSFETS. (*** SHORTCUT: This step can be skipped. If this is not a brand new power amp you can leave the potentiometers where they are, as to save time when setting the bias point of the VRF MOSFETS, in later steps. However in the case of the replacement of a power amp, when dealing with a brand new power amp board, note that the potentiometers are most probably turned all the way anti-clockwise already so that there is no bias on the gates of the MOSFETS.)
1.  Perform the ‘auto-balance’ function of the current probe. (PS Ensure that the probe is in a closed/locked state! Output of the scope on the TxRx channel should also be set to 1 MΩ).
    ###### Figure 12. Power Amplifier test station setup.
	![Power Amplifier test station setup.](images/hardware/amp_setup.jpg)
1.  Disconnect the HPSW from the Power Amp and terminate the output of the Power Amp (RF_OUT RF connector). with the dummy load.
1.  Switch on the transceiver box (mains) and Front Panel switch (15V) – NOT YET THE 30 V PSU SUPPLY!
1.  Check that the Tx/Rx signal is present on P1.
1.  Check that P12 is around 9.8V using the DMM.
1.  Remove the thermistor from P14 and P12 should increase by about 20mV. The shows that the thermal compensation is working. Plug the thermistor back in.
1.  Check that P10 is a switched version of P1.
1.  Check that J3 (the square hole connection) should be the inverse of P10.
    ###### Figure 13. P10 should be a switched 9.8V signal and J3 should be the inverse of P10.
	| ![Signal 13](images/hardware/signal_13.jpg) | ![Signal 14](images/hardware/signal_14.jpg) |
	| - | - |
1.  Check that Pin 5 of Q1 is a switched 12V signal. This powers the HELA10. Also check that J5 (pin1) is the inverse of Pin 5 of Q1.
    ###### Figure 14. Switched 12V to power the HELA10 and J5 should be the inverse of Q1 (pin5).
	| ![Signal 15](images/hardware/signal_15.jpg) | ![Signal 16](images/hardware/signal_16.jpg) |
	| - | - |
1.  (Only applicable for brand new power amp boards.) Check that all the gates on the MOSFETS are at 0V. If not, check that the potentiometers are completely turned down.
1.  (Only applicable for brand new power amp boards.) Note: the gates are pre-biased using the potentiometers, onto which the drive pulse is added. This makes switching everything faster.
1.  (Only applicable for brand new power amp boards.) VRF MOSFETS pre-bias around 3.5V while the MRF MOSFETS pre-bias around 3V. The VRF part is better as it has more gain and a higher breakdown.
1.  Switch the 30V supply on.
1.  Attach the current probe to the copper wire bridge on the drain leads. Attach the scope probe to the corresponding test point on the MOSFET’s gate. Turn the potentiometer clockwise until you get close to the pre-bias point (3.5V). At this stage the current in the drain will start to rise when the Tx/Rx signal is high. Keep adjusting until the current pulse level is 200mA in the centre. The current pulse will at first be asymmetrical because there are two MOSFETS (adjust the first one to 100mA). Adjust the second MOSFETS gate voltage and monitor the current until you get 200mA current pulses its drain. Go back to the first drain and re-adjust to 200mA, if necessary. (*** Make sure that the scope probe measuring the pre-bias point (Voltage – “Yellow”) is set to 1MΩ and that the oscilloscope triggers on this channel. Also make sure that the scope probe measuring the current pulse level (Amps – “Blue”) is set to 1 M$\Omega$ as well.)
1.  Repeat the above step for all 5 pairs.
1.  At this stage the current should read about 350mA @ 30V (410mA @ 50V).
1.  Switch off the 30V supply.
1.  Now connect the RF signal to the input (RF_IN on the power amp board) with an amplitude of -20 dBm and a frequency of 12.5 MHz.
1.  Slowly increase the RF power up to 4 dBm.
1.  RF (TP_IN) should be around 1V pk-pk; the output of the HELA10 (C12 and C14) should be around 2V pk-pk each and balanced; the input of the MOSFETS (“G” - Gate) should be about 750mV pk-pk. This tells us that the HELA10 is working. (*** NOTE: At an amplitude of -20 dBm you don’t see anything on the oscilloscope immediately. Just start increasing the amplitude slowly whilst carefully monitoring it, until the RF signal is observed as described above.)
	###### Figure 15. Input RF signal (P3) at 4 dBm is roughly 1Vp-p, the voltage at the outputs of the HELA10 should be about 2Vp-p and the voltage at the gate of the driver amp MOSFET should be 750mVp-p.
	| ![Signal 15](images/hardware/signal_15.jpg) | ![Signal 16](images/hardware/signal_16.jpg) |
	| - | - |
	| ![Signal 17](images/hardware/signal_17.jpg) | |
1.  Turn the RF power back down to -20dBm. - IMPORTANT!
1.  Turn the 30V on again.
1.  Measure the output voltage at the Power Amp output (P20 – TP_OUT). It should read around 11V pk-pk.
    ###### Figure 16. When the input is -20 dBm the output (P20) reads 11Vp-p.
	![Signal 18](images/hardware/signal_18.jpg)
1.  Slowly increase the input power. Carefully monitoring the output voltage. You will need to increase the current limiting on the PSU. At 0dBm you should see about 130V pk-pk. Keep increasing until you reach 600V pk-pk, this should be at an amplitude of about 7 dBms.
	###### Figure 17. When the input is 0 dBm the output (P20) reads 130Vp-p. The output starts to saturate with an input signal of about 14dBm the output reads 600Vp-p.
	| ![Signal 19](images/hardware/signal_19.jpg) | ![Signal 20](images/hardware/signal_20.jpg) |
	| - | - |
1.  Now look at the drain voltages for each MOSFET. It should be somewhat symmetrical but the positive side will ramp up higher and there could be some slight ringing. Check the 3R3 damping resistors, if there is significant ringing.
    ###### Figure 18. Drain voltage at 30V supply at 600Vp-p output. Check that there is not significant ringing on the drains of the MOSFET's and that the voltage does not exceed 170V.
	![Signal 21](images/hardware/signal_21.jpg)
1.  Turn the RF power back down to -20dBm. - IMPORTANT!
1.  If everything is okay then power off.
1.  Replace the 30V supply with the 50V supply (from the capacitor board) and repeat the above process, starting from -20dBm again and increasing to 950V pk-pk (This should be observed at an amplitude of more or less 13 dBms). Re-check all the drain voltages. We do not want to exceed 170V for the VRF’s. A typical value will be around 120V at 950V pk-pk output. (If a drain voltage exceeds these values; the corresponding VRF Mosfet should be checked and most likely be replaced.) (*** ALTERNATE STEP 32 (including the HPSW and filter in the RF path): Un-terminate RF_OUT, terminate Rx on the HPSW and reconnect the HPSW and Filter to the power amp. Connect the 100 W dummy load to the antenna port and measure the output at the output pin of the filter board. Replace the 30V supply with the 50V supply (from the capacitor board) and repeat the above process, starting from -20dBm again and increasing to 950V pk-pk (This should be observed at an amplitude of more or less 13 dBms). Re-check all the drain voltages. We do not want to exceed 170V for the VRF’s. A typical value will be around 120V at 950V pk-pk output. (If a drain voltage exceeds these values; the corresponding VRF Mosfet should be checked and most likely be replaced.))
1.  Turn the RF power back down to -20dBm. - IMPORTANT!
1.  Power down everything in the correct sequence.
    ###### Figure 19. Drain voltage at 50V supply at 900Vp-p output.
	![Signal 21](images/hardware/signal_22.jpg)

### FPGA

1.  Connect  Phoenix connector J4 to the Power Distribution Board.
1.  This will provide power to the FPGA board and the RF Transceiver Board. Re-check that the voltages are at 5V and 15V before proceeding.
1.  The FPGA Board has its own power regulation for all the different supply voltages it requires. The easiest way to check that these are all in order is to look on the Voltage Screen on the Front Panel. You can also check LED’s D9, D10, D11, D12 and D13. Fault finding will be difficult but try and check the DC-DC converter modules, if there is a problem with one of the voltages. For example 1.8V is mostly limited to the 1GIG Ethernet controller, so check there if there is an issue with 1.8V (this fault has happened before).
	###### Figure 20. Testing of FPGA and transceiver baord.
	![FPGA and Trasceiver board](images/hardware/box_fpga_txrx.jpg)

### RF Transceiver

1.  Connect the transceiver test board to the transceiver board and power it with 15 V from a test bench power supply.
1.  Verify that all 4 LEDs in the PWR LED bank on the transceiver test board are on.
1.  Verify that test pin P20 is at 10.5 V and P19 at 3.3 V on the transceiver board.
1.  Flip all of the switches on the transceiver test board on, one by one and verify that their corresponding LEDs respond accordingly (switch on and off when the switches are flipped).
1.  Switch on the AWG and set the frequency to 12.5 MHz and set the amplitude to 100mVp-p. Connect a BNC cable between the Output of the AWG and Channel 1 on the Agilent MSO6104A to view the waveform. Make sure to press “Output” on the front face to enable the waveform. Remember to set the impedance of the channel to 50$\Omega$ and use a 50$\Omega$ feed through connection on the oscilloscope channel being used. Check that the waveform displayed is correct.
1.  Connect the output of the AWG to the DAC2 port on the transceiver test board and Channel 1 on the Agilent MSO6104A to the DAC2_Out port on the transceiver board.
1.  Verify that the signal observed is the same 12.5 MHz, 100mVp-p signal with possible minor amplitude losses (~ 3 mV).
1.  Connect the output of the AWG to the DAC1(Tx) port on the transceiver test board and Channel 1 on the Agilent MSO6104A to the TxOUT port on the transceiver board.
1.  Verify that the signal observed is a 12.5 MHz, 25mVp-p signal. This is due to the Tx attenuator being set to maximum attenuation by default.
1.  Switch the LE (Latch Enable) of the Tx AGC bank on the transceiver test board on. This sets the Tx attenuator to minimum attenuation.
1.  Verify that the signal observed is a 12.5 MHz, 1Vp-p signal (800mV ~ 1V pk-pk).
1.  Switch through the attenuation switches in the Tx AGC bank on the transceiver test board one by one, starting at 1 dB all the way through to 16 dB. Verify after flipping each switch that the signal’s pk-pk amplitude decreases more and more with an increasing value of attenuation.
1.  Flip all the switches on the transceiver test board back to their original state (off).
1.  Connect the output of the AWG to the Antenna port on the transceiver board and Channel 1 on the Agilent MSO6104A to the MON2 port on the transceiver test board.
1.  Verify that the signal observed is the same 12.5 MHz, 100mVp-p signal with possible minor amplitude losses (~ 3 mV).
1.  Connect the output of the AWG to the Current port and terminate the Pwr_Amp port on the transceiver board and connect Channel 1 on the Agilent MSO6104A to the MON1 port on the transceiver test board.
1.  Verify that the signal observed is a 12.5 MHz, 70mVp-p signal with possible minor amplitude losses (~ 3 mV).
1.  Switch SWB on, on the transceiver test board.
1.  Verify that the signal observed is a 12.5 MHz, 50mVp-p signal with possible minor amplitude losses (~ 3 mV).
1.  Switch the power off.
1.  Connect the output of the AWG to the Pwr_Amp port and terminate the Current port on the transceiver board and connect Channel 1 on the Agilent MSO6104A to the MON1 port on the transceiver test board.
1.  Switch the power on.
1.  Verify that the signal observed is a 12.5 MHz, 50mVp-p signal with possible minor amplitude losses (~ 3 mV).
1.  Switch SWB off, on the transceiver test board.
1.  Verify that no signal is measured at the MON1 output port.
1.  Change the amplitude on the AWG to 1mVp-p as the amplification on the Rx signal path is very large and one does not want the output of the receiver to be more than 1V pk-pk.
1.  Connect the output of the AWG to the RFin port on the transceiver board. Connect Channel 1 on the Agilent MSO6104A to the ADC(Rx) port and terminate the DAC1(Tx) port, on the transceiver test board.
1.  Switch the LE (Latch Enable) of the Rx AGC bank on the transceiver test board on. This sets the Rx attenuator to minimum attenuation.
1.  Verify that the signal observed is a 12.5 MHz, 1Vp-p signal (800mV \~ 1V pk-pk).
1.  Switch through the attenuation switches in the Rx AGC bank on the transceiver test board one by one, starting at 1 dB all the way through to 16 dB. Verify after flipping each switch that the signal’s pk-pk amplitude decreases more and more with an increasing value of attenuation.
1.  Flip all the switches on the transceiver test board back to their original state (off).
1.  Switch the power off.
1.  Connect the output of the AWG to the DAC1(Tx) port and connect Channel 1 on the Agilent MSO6104A to the ADC(Rx) port on the transceiver test board and terminate the RFin port on the transceiver board.
1.  Change the amplitude on the AWG to 50mVp-p.
1.  Switch on the LE (Latch Enable) switches in the Tx AGC and Rx AGC banks on the transceiver test board.
1.  Switch SWA on, on the transceiver test board.
1.  Switch the power on.
1.  Verify that the signal observed is a 12.5 MHz, 1Vp-p signal (800mV ~ 1V pk-pk).
1.  Switch SWA off, on the transceiver test board.
1.  Verify that no signal is measured at the ADC(Rx) port on the transceiver test board.

Once you are comfortable with what needs to be terminated when, where and why you can use the following shortcut test sequence for the transceiver board. Make sure that the oscilloscope is setup to trigger on the channel being used to measure and test on! And ZOOM in on the oscilloscope as the signals being measured in this test are mostly all very small.

1.  Disconnect the transceiver board from the FPGA and unmount from the chassis.
1.  Connect the transceiver board to the “RF Transceiver Test Board Ver 1.2” and power this setup with an external 15 V from a bench power supply.
1.  Switch the power on and make sure all 4 power LEDs on the tester board light up; and that each LED corresponding to a DIP switch, switches on when the switch is turned on.
1.  Switch all switches off again.
1.  Switch on the AWG and set the frequency to 12.5 MHz and set the amplitude to 100mVp-p.
1.  Connect the output of the AWG to the DAC2 port and observe the same signal as output on DAC2_OUT.
1.  Connect the output of the AWG to the DAC1(Tx) port and observe a signal with an amplitude of ± 25 mV pk-pk on Tx_OUT.
1.  Flip the TxAGC (LE) switch on and observe a signal with an amplitude of ± 800 mV pk-pk on Tx_OUT.
1.  Flip the other TxAGC (1dB – 16dB) switches on one by one and observe an increasing attenuation of the signal on Tx_OUT, corresponding to flipping the switches of increasing dBs.
1.  Connect the output of the AWG to the Antenna port and observe the same signal as output on MON2.
1.  Connect the output of the AWG to the Current port and terminate the PwrAmp port; observe a signal with an amplitude of ± 70 mV pk-pk on MON1.
1.  Flip SWB switch on and observe the signal on MON1 drop in amplitude to ± 50 mV pk-pk.
1.  Switch the power off and swap the inputs to the Current and Pwr_Amp ports
1.  Switch the power back on and verify once more a signal with an amplitude of ± 50 mV pk-pk on MON1.
1.  Flip SWB switch off and observe the signal on MON1 disappear. Flip SWB switch on and back off again, watching the signal with an amplitude ± 50 mV pk-pk re-appear and disappear again on MON1.
1.  Power off and change the AWG output from 100 mV pk-pk to 1 mV pk-pk.
1.  Connect the output of the AWG to the RFin port and terminate the DAC1(Tx) port; observe the same signal output on ADC(Rx).
1.  Flip the RxAGC (LE) switch on.
1.  Power up the tester board and output the AWG; observe a signal with an amplitude of ± 800 mV pk-pk on ADC(Rx).
1.  Flip the other RxAGC (1dB – 16dB) switches on one by one and observe an increasing attenuation of the signal on ADC(Rx), corresponding to flipping the switches of increasing dBs.

### Transmit and Receive Tests

###### Figure 21. Setup of transceiver box, timing box, oscilloscope and server.
![Transceiver box testing setup](images/hardware/txrx_setup.jpg)

1.  Ensure all cables are plugged in; And the dummy load is connected to the antenna port
1.  On the computer (Joshua) go to /T3/cpart/ [Run command: cd /T3/cpart/]
1.  Run ./sop
1.  Ensure that there are 2 boxes alive (Timing box and Transceiver box being tested)
1.  Enter 1 for transmit test, then 3 to transmit
1.  You should hear the box switching and see the TxRx signal as well as the antenna output (500Vp-p) on the oscilloscope
1.  To stop the test, enter 5 for the receive test, replace the dummy load with AWG set to 9.9MHz @ 1mVp-p
1.  Run ./sop again and enter 0, then 3 to begin
1.  When you switch on the AWG you should see a waveform on the computer with amplitude 30 000 peak-to-peak
1.  To stop the test, enter 5

### Calibration

1.  For the calibration, replace the AWG input with the dummy load
1.  Run ./sop and enter 1, then 3 to transmit
1.  Once you hear the switching, press 4 to enter calibration
1.  Enter the box node number you wish to calibrate
1.  Once calibration is complete, do another transmit test and confirm antenna output is 500Vp-p

## Radar Server and Network
A diagram of the server network was shown in the [introduction](introduction.md#hardware-overview). The network and server shouldn't require a lot of maintenance. There is a spare server called Caleb to replace Joshua if it gives any problems. There are several spare parts for the servers as well, which can be found in the VLF store room.

As for the network, some of the LAN cables might get damaged from time to time. In this case they should simply be replaced with spare cables. These are kept in the radar hut too. Make sure that the type of cable is the correct one for the purpose you want to use it for. (The green ones - CAT6 - are especially for the timing cables from the timing box to the transceiver boxes. They should all be of the same length too.)

# Software

## RST
RST is the specialized radar software running on the server. The software sends commands to the radar timing and transceiver boxes, receives data packets back from them and processes this data.

Under normal circumstances, the radar engineer shouldn't have to change anything about this software. Stopping and starting the radar will stop and start the RST software and thus control the operation of the radar. If it is necessary to get involved with the code, there is comprehensive documentation available on the radar server PC as well as a hard copy in the radar office book case.

## FPGA
If the FPGA is new and empty (it will be flashing all its lights when switched on), you have to program it for the first time via JTAG emulator. If the FPGA is not empty and has been programmed before, the Ethernet connection to the radar server and simple program can be used to re-program the flash of the FPGA.

### Flashing an empty FPGA
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

## Front Panel
The front panel can be programmed using a Zilog programming device. It can be programmed directly from the Zilog IDE or using a .hex file and a generic programming software package.

The front panel code was update during 2017 and 2018. The newest version of the software, as well as the older versions, is available on the radar server. If the software is modified, a new version needs to be saved in the same folder. The most recent version should always be uploaded to the server as soon as possible to prevent any future installations that might be outdated.

When a new Lantronix module is installed in a transceiver box, the code needs to be updated to associate the box name with the MAC address provided on the Lantronix module.


## HPSW
It should only be necessary to program the CPLD on the HPSW once, right after it's been manufactured. This will most probably be done at SANSA Space Science in Hermanus. It can be programmed using JTAG and the code is available on the radar server as well.

This software is standard and doesn't require any modifications or upgrades.

# Standard Operating Procedures
This section provides a guide for the radar's day-to-day operation and maintenance. [Summary](#summary) provides all the details necessary to locate and access the instrument's system. [Daily Checks](#daily-checks) lists all items that need to be checked on a daily basis to ensure that the system is still operating properly. [Procedures](#procedures) explains the basic operating procedures for the system. [Monitoring](#monitoring) shows how the Grafana monitoring system interacts with the instrument's local server and [Reporting](#reporting) elaborates on how to generate monthly reports for the system.

When unsure about any of the automated tasks, just run this command: `crontab -l` to see which scripts are being run, where they're located and at what times they are set to execute.

## Summary
The tables below gives a summary of all the details necessary to locate, access and maintain the instrument's system.

###### Table 1. System details - Login
| Item | Description |
| ---- | ----------- |
| Internal IP Address | 172.17.31.50 |
| External IP Address | 155.232.186.23 |
| User Name | radar |
| Password | sanaeradar |

###### Table 2. System details - Details
| Item | Description |
| ---- | ----------- |
| Machine | SuperMICRO |
| Operating System | Ubuntu 14.04 |
| Instrument | SuperDARN HF Radar |
| NTP Serer | 172.17.30.8 |
| Location | Radar Hut |

###### Table 3. System details - Principle Investigator
| Item | Description |
| ---- | ----------- |
| Name | Judy Stephenson |
| Email Address | judes.stephenson@gmail.com |
| Affiliation | University of Kwa-Zulu Natal |

## Daily checks
Check the following at least once every day to ensure that the radar is working properly:
- Navigate to `/data/ros/fitacf/` and confirm that the latest data file is growing.
- Run the command: `screen -x`. Verify that the radar software is running.
- Use SCP and log into the SANRAD server. Make sure that the previous day's data transferred correctly. The transfer script is located at `/home/radar/transfer_data/script/sanrad_new`.
- The size of daily data files can vary, but should be between 10MB and 20MB, more or less. Very small data files might be a sign that the radar is running at low power.-

## Procedures
This section provides instructions on how to stop and start the radar software properly.

Smart Power Distribution Units can be accessed remotely to power cycle a specific port in the case of a single box giving problems. See below for instructions on how to do this.

### Stopping the Radar Software
To properly and safely switch off the radar, follow these steps:
1. Run this command in any terminal on the radar server: `stop.radar`.
1. Log the activity using the logging script.

### Starting the Radar Software
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

### Power Cycling the Entire Radar
The following steps can be used to completely shut down the radar:
1. Stop the radar software.
1. Switch off all of the radar transceiver boxes and the timing box from the front panels.
1. Switch off the radar server with the command: `sudo poweroff now`.

To switch the radar on again, follow these steps:
1. Switch the radar server on again at the power button. Wait for the server to boot up.
1. Switch on the timing box and then all of the transceiver boxes. Only switch on one transceiver box at a time for the same PDU, since switching all of them on at the same time will require a sudden surge of current to be supplied.
1. Start the radar software.

### Power cycling a specific port on the PDU
To power cycle a specific port on the PDU, follow these steps:
1. Stop the radar software first, if it wasn't already.
1. Run the script: `SANAE_PDU_Control.sh`. Follow the instructions provided by the script.

Alternatively, the PDU's can be accessed directly using a browser and navigating to the desired IP address. Use the following information to log in and adjust the settings for:
1. PDU IP range: 172.17.30.20-25
1. User name: apc
1. Password: apc

PDU Gateway: 172.17.30.10 (Used as keep-alive address)

| ID | IP | P1 | P2 | P3 | P4 | P5 | P6 | P7 | P8 |
| -- | -- | -- | -- | -- | -- | -- | -- | -- | -- |
| PDU1 | 172.17.30.20 | SW1 | NC | NC | NC | M4 | M3 | M2 | M1 |
| PDU2 | 172.17.30.21 | S2 | S1 | M8 | M7 | M6 | M5 | NC | NC |
| PDU3 | 172.17.30.22 | C2 | C1 | J1 | J2 | SW3 | T1 | Sc | SW2 |
| PDU4 | 172.17.30.23 | NC | NC | NC | NC | M12 | M11 | M10 | M9 |
| PDU5 | 172.17.30.24 | S4 | S3 | M16 | M15 | M14 | M13 | MP | NC |
| PDU6 | 172.17.30.25 | - | - | - | - | - | - | - | - | - |


- M1-M16 : Main Array Transceiver boxes.
- S1-S4 : Secondary Array Transceiver box (Currently not connected).
- T1 : Timing box 2 (Timing box 1 is faulty).
- J1-J2 : Joshua, main server. Redundant power supply.
- C1-C2 : Caleb, back-up server. Redundant power supply.
- SW1 : 8 port switch (fiber connection to base).
- SW2 : 20 control switch, 20 port data switch, Microtik router.
- SW3 : Fiber-Ethernet converters and 8 port D-link switch.
- Sc : Rack Screen.
- MP : Multi-plug.

## Activity Logging
A logging system for all of the instruments on base was implemented in 2018. The logging scripts and data can be found on the data server. Any activities or disturbances to any of the instruments should be logged using this system.

Data that is entered using the logging script is synced with the instrument PC as well as being fed into the influxDB database. From there the log entries can then be displayed live on the Grafana dashboards and read into the monthly reports automatically.

In case an entry needs to be deleted, a separate script needs to be run. This script will then delete the entry from the data server, instrument PC and the influxDB database. This section provides detailed instructions for logging entries, deleting entries and adding new systems.

## Logging an Activity
To log a new activity, run the script: `log.sh` and follow the instructions, as demonstrated by the following steps:

1. First, the script will display an enumerated list of all the registered systems. It will then prompt for an instrument number, corresponding to the instrument on which the activity is to be logged. Enter the number and then press the `Enter` key.
    ###### Figure 1. Logging a new activity: Step 1.
    ![Logging a new activity: Step 1.](images/operations/logger_1.jpg)

1. The next prompt will ask for the name of the person responsible. A default name is displayed, which is read from the universal configuration file. To select the default option provided, simply press the `Enter` key. If the default name is incorrect, type in the desired name and press `Enter`.
    ###### Figure 2. Logging a new activity: Step 2.
    ![Logging a new activity: Step 2.](images/operations/logger_2.jpg)

1. When asked for the date, once again a default value is displayed. The default date is that of the present day and if the event occurred on a previous day, that date should be entered in the correct format.
    ###### Figure 3. Logging a new activity: Step 3.
    ![Logging a new activity: Step 3.](images/operations/logger_3.jpg)

1. The time is then prompted, once again with the current time as default. Press `Enter` or type in the desired time for the event.

    ###### Figure 4. Logging a new activity: Step 4.
    ![Logging a new activity: Step 4.](images/operations/logger_4.jpg)

1. The new status of the system can then be selected from a list of options. These include 0 (the system is off and no data is being logged), 1 (the system is logging data, but interference caused it to be invalid) and 2 (the system is up and logging valid data). Select one of these options and press `Enter`.

    ###### Figure 5. Logging a new activity: Step 5.
    ![Logging a new activity: Step 5.](images/operations/logger_5.jpg)

1. Finally, the user is asked to elaborate on the reason behind the event. Provide as much information as possible, typing in full sentences. Avoid using special characters as part of this entry. When done, press `Enter` and wait for the logs to be synchronized and uploaded to the influxDB database.

    ###### Figure 6. Logging a new activity: Step 6.
    ![Logging a new activity: Step 6.](images/operations/logger_6.jpg)

### Deleting an Activity
To delete a faulty activity entry, run the script: `del.sh` and follow the instructions, as demonstrated by the following steps:

1. First, the script will display an enumerated list of all the registered systems. It will then prompt for an instrument number, corresponding to the instrument on which the activity is to be logged. Enter the number and then press the `Enter` key.

    ###### Figure 7. Deleting an activity: Step 1.
    ![Deleting an activity: Step 1.](images/operations/delete_1.jpg)

1. When asked for the date, once again a default value is displayed. The default date is that of the present day and if the event occurred on a previous day, that date should be entered in the correct format.

    ###### Figure 8. Deleting an activity: Step 2.
    ![Deleting an activity: Step 2.](images/operations/delete_2.jpg)

1. The script will then display an enumerated list of all the activities logged for the date previously specified. Enter the number corresponding to the faulty entry and press `Entry` to delete that entry. Wait for the logs to be synchronized with the instrument PC and influxDB database.

    ###### Figure 9 Deleting an activity: Step 3.
    ![Deleting an activity: Step 3.](images/operations/delete_3.jpg)

### Adding a New Instrument

## Monitoring
A live monitoring system for all of the instruments on base have been implemented in Grafana, working with an InfluxDB back-end. This section explains how this system works, from the data collection scripts, reading data into the InfluxDB databases and displaying the data and statistics on a Grafana dashboard.

### Overview
For each system, data is transferred to the data server at set intervals. These intervals can be seen and set in the crontab of the data server. The data collector script, which is called by the crontab, runs a datacrawler script on the instrument PC via ssh. These datacrawlers are responsible for reading the most recent data and formatting it to comply with the influxDB Line Protocol. The file containing the database entries is then transferred to data server, from where it is read into the influxDB database. Refer to \figref{ops_monitoring} below.

###### Figure 10. Monitoring System Overview.
![Monitoring System Overview.](images/operations/grafana_graphic.pdf)

Graph and explanation of datacollector, datacrawler, influx, grafana, etc.

### Scripts
### Backfilling
### InfluxDB
### Grafana

scripts, data, backfilling, influx commands, retention policy

## Reporting
script and how to copy to desktop. (Luatex for memory problems)