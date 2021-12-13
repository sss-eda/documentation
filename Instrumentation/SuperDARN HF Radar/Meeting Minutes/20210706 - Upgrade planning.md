# SuperDARN Upgrades Planning

## Content
[Attendance](#attendance)  
[Agenda](#agenda)  
[Minutes](#minutes)  
[Action Items](#action-items)  

## Attendance
- [x] Jon Ward  
- [x] Pierre Retief  
- [x] Mfezeko Rataza  
- [x] Thobane Mabaso  
- [x] Stpehanus Schoeman

## Agenda
1. [Mabel](#1-mabel)
2. [FPGA Hardware](#2-fpga-hardware-mods)
3. [FPGA Firmware](#3-fpga-firmware)
4. [Front Panel](#4-front-panel)
5. [HPSW](#5-hpsw)
6. [Filter Board](#6-filter-board)
7. [Training](#7-training)


## Minutes

### 1. Mabel
* The new engineers will learn how to work with the old ROS and RST first, since that is how the system is currently working.

* We will have to write new calibration software for our oscilloscope, we can look at that once we recieve the new software package from the Australians.

* Mabel needs to be installed and tested here in Hermanus. Once we have the system working and we have documented everything properly, we can give the final go for upgrading the system at SANAE IV as well.

* The plan is to do routine annual upgrades from now on.

### 2. FPGA Hardware Mods
* Do the proposed mod on the 1V supply on one FPGA and test it with the new FPGA firmware first. If this works, do the mod on all the boards here in Hermanus and write work instructions for doing the mod at SANAE IV as well. 

### 3. FPGA Firmware
* We will recieve the new packaged software by Friday. Once we have it, install the new firmware on the development box FPGA and test with Mabel installation.

### 4. Front Panel
* We need to design the new PCB that will work with the Raspberry Pi's.

* We already have most of the components needed for the new boards, but still need to procure the rotary switches. And the PCB's of course.

### 5. HPSW
* We will try to start going over to the new HPSW board - version D. We need to do the procurement for any new parts or parts we don't have enough of.

### 6. Filter Board
* We need funds to do this first. Project in ICE BOX for now.

* Assemble a parts list so long.

### 7. Training
* On the 6<sup>th</sup> of July 2021, Pierre will start training the new engineers on the transceiver box service procedure.

* After service box procedure training is done, trianing on RMS will commence. Pierre will schedule a demo of the software.

## Action Items

### Design new FP PCB
> * Jon

### Upgrade work orders & parts lists
> * Jon

### Training: Box Servicing Procedure
> * Pierre - Presenter
> * Fez - Trainee
> * Thobane - Trainee

### Training: RMS Demo and Training
> * Pierre - Presenter
> * Fez - Trainee
> * Thobane - Trainee
> * Jon - Attend Demo
> * Stephanus - Attend Demo

### Install and test Mable
> * Stephanus - Oversee and document
> * Pierre - Lead (provide documents of previous install)
> * Fez - Observe
> * Thobane - Observe

### New Oscilloscope Callibration Software
> * Jon - Collaborate
> * Stephanus - Collaborate

### HPSW Hardware Mod
> * Stephanus - Test first & assemble work instruction

### Procurement
> * Jon - Provide parts lists
> * Stephanus - Procure from RS what we can, start RFQ for the rest
