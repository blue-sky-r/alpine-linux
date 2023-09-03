#!/bin/bash

# CPU and HDD temperature probe for MRTG
#

# CPU
#
CPU_OFS=20
echo $(( $(cat /sys/class/hwmon/hwmon0/temp2_input) / 1000 + CPU_OFS ))

# HDD
# sudo chmod +s /usr/sbin/smartctl
HDD=/dev/sda
smartctl -a $HDD | awk -v ofs=$HDD_OFS '/Temperature_Celsius/ {print $10}'

# Line 3
# 82360.60 163181.37
cat /proc/uptime | awk '{s=$1; d=int(s/86400); s=s%86400; h=int(s/3600); s=s%3600; m=int(s/60); s=s%60; printf "%dd %dh %dm %ds\n",d,h,m,s}'

# Line 4
#
echo $HOSTNAME
