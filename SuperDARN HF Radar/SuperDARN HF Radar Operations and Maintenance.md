# SuperDARN HF Radar
## Operations and Maintenance

### Introduction
This manual serves as a comprehensive guide to maintaining the SuperDARN high frequency radar at SANAE IV. This section of the manual provides a concise background on the SuperDARN Radar, how it works and what it looks for.


#### Infrastructure Overview
The infrastructure of the radar and the maintenance thereof is discussed in depth in [Introduction](#introduction). The radar's infrastructure consist of 20 antenna masts and a hut which houses all of the radar's transceiver and server equipment, as well as the network and electricity connection to the base infrastructure.

The radar hut is located about 600m South-East of the base at the center of the main antenna array, as shown in [Figure 1](#figure-1-site-map). There is a lifeline stretching from the base to the radar hut, as indicated on the map in \figref{intro_map}.

###### Figure 1. Site Map
![intro_map](images/introduction/map.bmp)

Electricity is relayed from the base to the radar hut, from where it is also distributed to the small satellite dome where the ozone radiometer is located. The power is not connected to the base UPS's, so the radar has its own small UPS. For more information on the radar hut, refer to \subsecref{infra_hut}.

There is 20 antenna masts forming part of the radar infrastructure on which the antennas are mounted. See \subsecref{infra_masts} for more details on the maintenance and climbing of these masts.

\clearpage

\subsection{Hardware Overview}
\label{subsec:intro_hw}
The hardware of the radar and the maintenance thereof is discussed in depth in \secref{hardware}. The radar has a main antenna array consisting of 16 antennas and a secondary array with 4 antennas. Each of these antennas is driven by a transceiver box, interconnected by the radar's server network.
\par
The antennas are hexagonal and consist of two halves, as shown in \figref{intro_antenna} below. \subsecref{hw_antennas} provides more details on the construction and maintenance of the antennas.

\vfill
\begin{figure}[H]
	\centering
	\includegraphics[width=0.9\textwidth]{images/introduction/antenna.jpg}
	\caption{A radar antenna}
	\label{fig:intro_antenna}
\end{figure}
\vfill

\subsecref{hw_boxes} provides step-for-step instructions on the servicing and maintenance of the radar's transceiver boxes. \figref{intro_box} shows the basic layout for the front and back of a radar transceiver box.
\par
The configuration of the server and network setup is demonstrated in the diagram shown in \figref{intro_hw}. The local radar network consists of a timing, control and monitoring network. The server is also connected to the base's science network and thus also the internet. More details concerning the maintenance of the server network can be found in \subsecref{hw_network}.

\vfill
\begin{figure}[H]
	\centering
	\includegraphics[width=0.9\textwidth]{images/introduction/box_diagram.jpg}
	\caption{Radar transceiver box layout}
	\label{fig:intro_box}
\end{figure}
\vfill
\begin{figure}[H]
	\centering
	\includegraphics[width=0.9\textwidth]{images/introduction/layout.pdf}
	\caption{Network layout of the radar hardware}
	\label{fig:intro_hw}
\end{figure}
\vfill

\clearpage

\subsection{Software Overview}
\label{subsec:intro_sw}
The radar's various software components are discussed in depth in \secref{software}. The radar has several components that requires their own specialized software:
\begin{itemize}
	\item RST - Radar control software installed on the radar server
	\item VHDL code installed on the T3 FPGA Board
	\item C Code installed on the Front Panel processor
	\item VHDL code installed on the HPSW FPGA
\end{itemize}
\par
The RST software is mostly written in C and was developed to produce a standard data product for all SuperDARN radars. All of the source code is available, but rarely gets updated or changed. See \subsecref{sw_rst} for more information.
\par
The VHDL source code for the T3 FPGA board isn't fully available, but is currently being adapted to allow for operation of the secondary array too. The file for reprogramming the board is available, should one of them start giving problems. See \subsecref{sw_fpga} for more details.
\par
C code for the Front Panel's Zilog processor is available and will need to be updated from time to time. This code is responsible for monitoring the state of each transceiver box: On the Front Panel LCD as well as remotely via the server's monitoring network. Refer to \subsecref{sw_fp} for more details.
\par
The high power switches have a small CPLD installed on them for monitoring, control and communication purposes. The VHDL code for these chips are available, but shouldn't require any changes. Should one of the boards give problems, they can be reprogrammed. Refer to \subsecref{sw_hpsw} for more details.

\clearpage

\subsection{Standard Operating Procedure Overview}
\label{subsec:intro_ops}
\secref{operations} gives detailed information about the standard operating procedure for the radar. This includes instructions for daily checks to be performed, operating the radar, monitoring the radar's performance and generating monthly reports.
\par
\subsecref{ops_summary}, \subsecref{ops_dailychecks} and \subsecref{ops_procedures} provide all of the information necessary for the radar's everyday operations.
\par
\subsecref{ops_monitoring} provides details on the remote monitoring system implemented for all of the instruments. The Grafana monitoring software works on an influxDB back-end.
\par
\subsecref{ops_reporting} gives instructions and information on the automatic reporting software used to generate a skeleton for each monthly report.


\clearpage