#!/bin/bash

# CPU and HDD temperature probe for MRTG
#
# about
#
_about_="CPU/HDD temperature probe for mrtg"

# version
#
_version_="2023.09.07"

# github
#
_github_="https://github.com/blue-sky-r/alpine-linux/blob/main/mrtg/usr/bin/mrtg-probe-cpu-hdd-temp.sh"

# optional requirements
#
_requires_="> chmod +s /usr/sbin/smartctl"

# HD smart capable and temperature value offset
#
hdd='/dev/sda'
#
hdofs=0

# CPU HW monitor and temperature value offset
#
cpu='/sys/class/hwmon/hwmon0/temp2'
#
cpuofs=20

# usage help
#
[ "$1" == "-h" ] && cat <<< """
= $_about_ = ver $_version_ =

usage: $0 [-h] [-d] [-cpu mon] [-cpuofs val] [-hd dev] [-hdofs val]

-h          ... show this usage help
-d          ... print additional debug info
-cpu mon    ,,, use cpu hw monitor (default $cpu) [_input/_label will be used]
-cpuofs val ... cpu temperature value offset (default $cpuofs)
-hd dev     ,,, use device dev (default $hdd)
-hdofs val  ... hd temperature value offset (default $hdofs)

Requires: $_requires_

$_github_
""" && exit 1

# optional debug
#
[ "$1" == "-d" ] && DBG=1 && shift

# optional cpu hw monutor
#
[ "$1" == "-cpu" ] && cpu=$2 && shift 2

# optional cpu temp. offset
#
[ "$1" == "-cpuofs" ] && cpuofs=$2 && shift 2

# optional hd dev
#
[ "$1" == "-hd" ] && hdd=$2 && shift 2

# optional hd temp. offset
#
[ "$1" == "-hdofs" ] && hdofs=$2 && shift 2

# CPU
#
[ $DBG ] && echo -n "CPU[$(cat ${cpu}_label) ${cpu}_input] + offset:$cpuofs = temp: "
echo $(( $(cat ${cpu}_input) / 1000 + cpuofs ))

# HDD
#
[ $DBG ] && echo -n "HDD[$hdd] + offset:$hdofs = temp: "
smartctl -A $hdd | awk -v ofs=$hdofs '/Temperature_Celsius/ {print ofs+$10}'
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
