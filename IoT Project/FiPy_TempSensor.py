#Measuring temperature with PT100 sensor
import time
import machine

adc = machine.ADC()
apin = adc.channel(pin='P16')
while True:
  print("")
  print("Reading Temp Sensor...")

  millivolts = apin.voltage()
  degC = (millivolts - 500.0) / 10.0
  degF = ((degC * 9.0) / 5.0) + 32.0

  print(millivolts)
  print(degC)
  print(degF)

  time.sleep(5) 
