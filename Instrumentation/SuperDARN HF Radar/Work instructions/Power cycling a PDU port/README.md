# Power cycling a specific port on the PDU

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