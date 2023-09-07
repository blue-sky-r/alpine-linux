#!/bin/bash

# HDD SMART attributes probe for MRTG - (extended) attributes are vendor dependent

# Common HDD:
#   1 Raw_Read_Error_Rate     0x000f   200   200   051    Pre-fail  Always       -       0
#   5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail  Always       -       0
#   7 Seek_Error_Rate         0x002f   200   200   051    Pre-fail  Always       -       0
#
# Toshiba HDD:
# 187 Reported_Uncorrect      0x0032   016   016   000    Old_age   Always       -       0
# 197 Current_Pending_Sector  0x0012   100   100   000    Old_age   Always       -       0
#
# WD HDD:
# 196 Reallocated_Event_Count 0x0032   200   200   000    Old_age   Always       -       0
# 197 Current_Pending_Sector  0x0012   200   200   000    Old_age   Always       -       0
# 198 Offline_Uncorrectable   0x0010   200   200   000    Old_age   Offline      -       0

# about
#
_about_="S.M.A.R.T. attribute probe for mrtg"

# version
#
_version_="2023.09.07"

# github
#
_github_="https://github.com/blue-sky-r/alpine-linux/blob/main/mrtg/usr/bin/mrtg-probe-smart.sh"

# optional requirements
#
_requires_="> chmod +s /usr/sbin/smartctl"

# example
#
_example_="> $0 -k 300 Raw_Read_Error_Rate Reallocated_Sector_Ct"

# default smart device
#
hdd='/dev/sda'

# multiplication koeficient (default 1, for mrtg use 5m = 5*60 = 300)
#
k=1

# usage help
#
[ "$1" == "-h" -o $# -lt 2 ] && cat <<< """
= $_about_ = ver $_version_ =

usage: $0 [-h] [-d] [-hd dev] [-l] [-k val] attr1 attr2

-h      ... show this usage help
-d      ... print additional debug info
-hd dev ,,, use device dev (default $hdd)
-l      ... list SMART attributes for device
-k val  ... multiplication value (default $k)
attr1   ... smart attrinute name I
attr2   ... smart attribute name O

Requires: $_requires_

Example:  $_example_

$_github_
""" && exit 1

# optional debug
#
[ "$1" == "-d" ] && DBG=1 && shift

# optional gd dev
#
[ "$1" == "-hd" ] && hdd=$2 && shift 2

# optional list smart attrs
#
[ "$1" == "-l" ] && smartctl -A $hdd && shift

# multiplication koeficient
#
[ "$1" == "-k" ] && k=$2 && shift 2

# attributes parameters
#
attr1=$1
attr2=$2

# print smart attrs from hd dev
#
smartctl -A $hdd | awk -v k=$k -v dbg=${DBG:-0} '/'$attr1'/ {v1=k*$10} /'$attr2'/ {v2=k*$10} \
    END { if (dbg) printf "DBG.I: hd['$hdd'].attr1['$attr1'] x '$k' = "; print v1; \
          if (dbg) printf "DBG.O: hd['$hdd'].attr2['$attr2'] x '$k' = "; print v2  }'
#
exitcode=${PIPESTATUS[0]}
[ $DBG ] && echo "DBG: smartctl.exitcode: $exitcode"

# Line 3
# 82360.60 163181.37
[ $DBG ] && echo -n "DBG.uptime: "
cat /proc/uptime | awk '{s=$1; d=int(s/86400); s=s%86400; h=int(s/3600); s=s%3600; m=int(s/60); s=s%60; printf "%dd %dh %dm %ds\n",d,h,m,s}'

# Line 4
#
[ $DBG ] && echo -n "DBG.host: "
echo $HOSTNAME

# return smartctl exitcode to the caller
#
exit $exitcode
