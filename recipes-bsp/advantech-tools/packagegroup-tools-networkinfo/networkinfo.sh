#!/bin/bash
ifconfig > /etc/networkinfo_temp
cat /etc/networkinfo_temp
read -p "Please input : " input