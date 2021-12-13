# Introduction
This manual serves as a comprehensive guide to maintaining the SuperDARN high frequency radar at SANAE IV. This section of the manual provides a concise background on the SuperDARN Radar, how it works and what it looks for.

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




