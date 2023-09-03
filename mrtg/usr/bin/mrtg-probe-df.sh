#!/bin/bash

# Disk free probe for MRTG
#
# usage: $0 [[mount-poit-1] [mount-point-2]]
#

# Filesystem     1K-blocks    Used Available Use% Mounted on
# devtmpfs           10240       0     10240   0% /dev
# shm              1026676       0   1026676   0% /dev/shm
# /dev/sda3       45225008 1053764  41850860   3% /
# tmpfs             410672     132    410540   1% /run
# /dev/sda1          90333   22032     61133  27% /boot
# /dev/sda4      104215768   98684  98800172   1% /var

# df
#
MOUNTI=${1:-/}
df | awk '/'${MOUNTI//\//\\/}'$/ {print 1024*$4}'

# df
#
MOUNTO=${2:-/var}
df | awk '/'${MOUNTO//\//\\/}'$/ {print 1024*$4}'

# Line 3
# 82360.60 163181.37
cat /proc/uptime | awk '{s=$1; d=int(s/86400); s=s%86400; h=int(s/3600); s=s%3600; m=int(s/60); s=s%60; printf "%dd %dh %dm %ds\n",d,h,m,s}'

# Line 4
#
echo $HOSTNAME
