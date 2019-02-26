#!/bin/bash

if [[ $(($(date +%s) - $(date +%s -r /etc/crontab))) -lt 86400 ]]
then
	    echo "Subject: Crontab was modified - $(date +%c -r /etc/crontab)" | sudo ssmtp root
fi
