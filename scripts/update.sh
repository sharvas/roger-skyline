#!/bin/bash

sleep 2
date >> /var/log/update_script.log
sudo apt-get -y update >> /var/log/update_script.log
DEBIAN_FRONTEND=noninteractive sudo apt-get -y upgrade >> /var/log/update_script.log
