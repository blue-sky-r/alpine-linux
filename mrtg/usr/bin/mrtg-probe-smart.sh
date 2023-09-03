#!/bin/bash

# HDD SMART attributes probe for MRTG
# https://harshasnmp.wordpress.com/2020/10/07/how-to-check-smart-failure-predict-status-of-drives-in-windows-10/

# multiplication koeficient (default 1, for mrtg use 5m = 5*60 = 300)
#
k=${1:-1}

# HDD
# sudo chmod +s /usr/sbin/smartctl
HDD=/dev/sda

# 187 Reported_Uncorrect      0x0032   016   016   000    Old_age   Always       -       84
# 197 Current_Pending_Sector  0x0012   100   100   000    Old_age   Always       -       9
#
smartctl -A $HDD | awk -v k=$k '/Reported_Uncorrect/ {print k*$10} /Current_Pending_Sector/ {print k*$10} '

# Line 3
# 82360.60 163181.37
cat /proc/uptime | awk '{s=$1; d=int(s/86400); s=s%86400; h=int(s/3600); s=s%3600; m=int(s/60); s=s%60; printf "%dd %dh %dm %ds\n",d,h,m,s}'

# Line 4
#
echo $HOSTNAME
