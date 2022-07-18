#!/usr/bin/env python3
#This is a test script to send email reports
import smtplib, email
from email import encoders
from email.mime.base import MIMEBase
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
import pandas as pd

#Introduction
print("This script will send a email on a daily basis through a cron job.")
date_str = pd.Timestamp.today().strftime('%Y-%m-%d')
subject = f'SANSA - Marion Island UltraMSK Daily Plots - {date_str}'
#subject = 'SANSA - Marion Island UltraMSK Daily Plots'
sender_email = 'sansaultramsk@gmail.com'
receiver_email = ['vwykdirk@gmail.com', 'djvanwyk@sansa.org.za', 'jward@sansa.org.za', 'slotz@sansa.org.za', 'Tankiso.Moso@gmail.com', 'tmoso@sansa.org.za']
#Email credentials
UserName = 'sansaultramsk@gmail.com'
Password = 'ultramsk@2022'
#Create a multipart message and setting headers
message = MIMEMultipart()
message["From"] = sender_email
message["To"] = ','.join(receiver_email)
message["Subject"] = subject
# message["Cc"] = receiver_email
body = 'New email testing to send the ultramsk Quicklooks on a daily basis in a compress folder for the previous day.'
message.attach(MIMEText(body, "plain"))
filename = "/home/sansa/msk1/MARMSK1.tar.gz"   # Must be in same directory as this script
attachment= open(filename, "rb")
p = MIMEBase('application','octet-stream')
p.set_payload((attachment).read())
print("Building message...")
# Open file in binary mode
#with open(filename, "rb") as attachment:
#    part = MIMEBase("application", "octet-stream")
#    part.set_payload(attachment.read())

# Encode file is ASCII format to email
encoders.encode_base64(p)
p.add_header('Content-Disposition', "attachment; filename= %s" % filename)
#part.add_header('Content-Disposition','attachment', filename= 'XXX_EW_MAR_20220215.png')

# Add the attachment to email and convert message to string
message.attach(p)
text = message.as_string()


print("Attempting to start mail server...")
#Mail server startup, port 587 fro startttls
Server = smtplib.SMTP('smtp.gmail.com:587')
# Try to log in on the server and send email
print("Attempting to start SMTP connection...")
try:
#Google mail server uses SMTP connections
    Server.starttls()
    print("Attempting to log in on mail server...")
    Server.login(UserName,Password)
    print("Trying to send mail... ")
    Server.sendmail(sender_email, receiver_email, text)
    print("Email sent!")
except Exception as e:
    print(e)
finally:
    print("Exiting mail server...")
    Server.quit()
