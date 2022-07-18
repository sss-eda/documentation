from network import WLAN
import machine
wlan = WLAN(mode=WLAN.STA)
wlan.antenna(WLAN.EXT_ANT)

wlan.connect(ssid='SANSA-GUEST', auth=(WLAN.WPA2, '5Ed88*bzaRc5'))
while not wlan.isconnected():
    machine.idle()
print("WiFi connected succesfully")
print(wlan.ifconfig())
