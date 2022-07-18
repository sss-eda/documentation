from machine import Pin, PWM

pwm = machine.PWM(0, frequency=50)
servo = pwm.channel(0, pin='P7', duty_cycle=0.5)
time.sleep(4)
servo.duty_cycle(0.032)
time.sleep(4)
servo.duty_cycle(0.127)
time.sleep(4)
servo.duty_cycle(0)
