# Data Protocol

Data could be recorded to Compact Flash (CF) card, personal computer or both devices. The CF card binary file format description is given in the Table 1. The data stream format from LEMI to PC is given in the Table 2. LEMI sends data to PC each second. LEMI is controlled by and communicates with PC using the protocol described in the Table 3. The communication interface - RS232, 57600 baud, start bit, 8 data bits, stop bit.

###### Table 1. LEMI-025 Compact Flash Data Format 
| Title |   | # | Bytes | Comments |
| ----- | - | ------ | ----- | -------- |
| Caption | | | 32 | |
| | 0x4c | 0 | 1 | Char, ASCII code of symbol “L” |
| | 0x30 | 1 | 1 | Char, ASCII code of symbol “0” |
| | 0x32 | 2 | 1 | Char, ASCII code of symbol “2” |
| | 0x35 | 3 | 1 | Char, ASCII code of symbol “5” |
| Station number | 0x47 | 4 | 1 | Binary-decimal number |
| Year | | 5 | 1 | Binary-decimal number |
| Month | | 6 | 1 | Binary-decimal number |
| Date | | 7 | 1 | Binary-decimal number |
| Hours | | 8 | 1 | Binary-decimal number |
| Minutes | | 9 | 1 | Binary-decimal number |
| Seconds | | 10 | 1 | Binary-decimal number |
| Latitude<sup>*1</sup> | | 11-15 | 5 | Binary-decimal number |
| Longitude<sup>*2</sup> | | 16-21 | 6 | Binary-decimal number |
| STATUS GPS | | 22 | 1 | Char, “A” – Active; “P”-Passive, “O” – no antenna, “S” – short circuited cable. |
| | 0x00 | 23 | 1 | Reserved byte |
| Voltage UIN | UIN*10 | 24 | 1 | uint8 |
| Bias field, uT | BX-DAC *400 | 25-26 | 2 | int16; little-endian format |
| | BY-DAC *400 | 27-28 | 2 | int16; little-endian format |
| | BZ-DAC *400 | 29-30 | 2 | int16; little-endian format |
| | | 31 | | Service information |
| Reading 1, including | | | 16 | |

| Magnetic variations, uT |
BX-Var 0 – 3 4 BX   -  Var, BY   -  Var, BZ   -  Var –
float32
(little-endian format)
BY-Var 4 – 7 4
BZ-Var 8 – 11 4
Temperature,
C*100
TF*100 12-13 2 int16 (little-endian format)
TF – sensor and TE – electronic un.TE*100 14-15 2
... ... Readings 2-29
Reading 30 16
512 32 + 30*16 = 512Example of position codes: *1: 49 47 94 45 4e   => 49° 47.9445' N
*2: 00 24 00 54 96 45  => 0024° 00.5496' E
Char – ASCII character, unsigned integer, 8 bits.
uint8 - unsigned integer, 8 bits; int8  - signed integer, 8 bits.
int16 - signed integer, 16 bits; float32 - floating-point, 32 bits.
1
Table 2. Data stream from LEMI-025 to PC
N# of
byte in
the
packet
Name Description Comments
0 L L025
1 0
2 2
3 5
4 Station number 1 - 255
5 Year 00000101 Binary-decimal number; 05
6 Month 00010000 Binary-decimal number; 10
7 Day 00010010 Binary-decimal number; 12
8 hour Binary-decimal number;
9 minute Binary-decimal number;
10 second Binary-decimal number;
11-12 Data TF*100  int16; little-endian format
TF – sensor and TE – electr. un.13-14 Data TE *100
15-16 DAC-X int16; little-endian format
Counts of the  digital-to-analog
converter (DAC) of the bias subunit17-18 DAC-Y
19-20 DAC-Z
21-22 BX-DAC*400 int16; little-endian format
(Bias field)*400, uT
rounded to 2.5 nT
23-24 BY-DAC *400
25-26 BZ-DAC *400
27 Reserved byte 0x00
28-39 Data BX-Var Reading 1
12 bytes
float32 (little-endian format)
Magnetic variations data, uTData BY-Var
Data BZ-Var 
40-51 Reading 2
52-147 Readings 3-10
148 MODE  uint8 
1 – FLASH
2 – PC
3 – Flash + PC
149 FLASH FREEuint8;
free volume of memory, %
150 Voltage UIN UIN*10 uint8; Battery voltage
151 STATUS GPS Char; “A” – Active; “P”-Passive, “O” –
no antenna, “S” – short circuited 
cable.
152 Check sum
NOTE! The magnetic data transferred from LEMI to PC are assigned to the nearest time
mark   received   from   GPS   and   the   necessary   time   scale   correcting   shift   (-0.3   second)   is
carried out by the PC software.
2
Table 3. Communications protocol between LEMI-025 and PC
# Command
name
Command code / response Comments
1 2 3 4 5 6 7 8
1 Read time 3D 31 - - - - - - PC => LEMI
3F 31 05Year
13Day
11Month
23Hour
15Min
59Sec
LEMI => PCBinary-decimal numbers
2 Set time 3D 32 05Year
13Day
11Month
23Hour
15Min
59Sec
PC => LEMIBinary-decimal numbers
3F 32 05Year
13Day
11Month
23Hour
15Min
59Sec
LEMI => PCBinary-decimal numbers
3 Set 
coefficients 1  3D 33 XX Mode - - - -
PC => LEMIMode:
1 – FLASH
2 – PC
3 – FL + PC
3F 33 00 Mode LEMI => PC
4* Read 
coefficients 1
3D 34 - - - - - - PC => LEMI
3F 34 00 Mode UIN*10 Mode1
LEMI => PCMode1: 
0 – menu; 1 – record
5 Set 
coefficients 2
3D 35 XX XX Ax1 PC => LEMI
float32; little-endian
format
Ay1 Az1
Beta Gamma
Xi Exy
Eyz Exz
K1x K1y
K1z K2x
K2y K2z
KTF KTE
KTF0 KTE0
KVBAT
3F 35 - - - - - - LEMI => PC
6 Read 
coefficients 2
3D 36 - - - - - - PC => LEMI
3F 36 XX XX Ax1 LEMI => PC
float32; little-endian
format
Ay1 Az1
Beta Gamma
Xi Exy
Eyz Exz
K1x K1y
K1z K2x
K2y K2z
KTF KTE
KTF0 KTE0
KVBAT -
3
# Command
name
Command code / response Comments
1 2 3 4 5 6 7 8
7 Read GPS 
data
3D 37 XX XX - - - - PC => LEMI
3F 37 Latitude (5 bytes) Lo... LEMI => PCBinary-decimal numbersLongitude (6 bytes) Altitude (3 bytes)
8 Read Config 3D 30 XX XX - - - - PC => LEMI
3F 37 30
(‘0’)
32
(‘2’)
35
(‘5’)
20
(‘ ’)
SN LEMI => PCBinary-decimal numbers
SN -  Station number
9* Stop_system 3D 38 - - - - - - PC => LEMI
There is no response
from LEMI!
10 Start_system 3D 39 - - - - - - PC => LEMI
3F 39 - - - - - - LEMI => PC
11 Check 
FLASH
3D 3A PC => LEMI
3F FL-size_MB
uint16; LE
FLfree
uint8 - - - - LEMI => PC
12* Set DAC-X 3D 3D DAC-X - - - - - PC => LEMIint16
There is no response
from LEMI!
13* Set DAC-Y 3D 3EDAC-Y - - - - - PC => LEMIint16
There is no response
from LEMI!
14* Set DAC-Y 3D 3F DAC-Z - - - - - PC => LEMIint16
There is no response
from LEMI!
Notes: The microcontroller executes commands marked by the asterix “*” in the data recording
mode only. Other commands (not marked by “*”) are executed when there is no data recording. 