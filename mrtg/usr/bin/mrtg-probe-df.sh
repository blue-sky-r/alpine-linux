#!/bin/bash

# Disk free probe for MRTG
#
# usage: $0 [[mount-poit-1] [mount-point-2]]
#

# Filesystem     1K-blocks   Used Available Use% Mounted on
# tmpfs             409552    132    409420   1% /run
# tmpfs            1023876    432   1023444   1% /tmp
# /dev/sda1          90195  23063     62320  28% /boot
# /dev/sda2        6618204 310936   5970324   5% /
# /dev/sda3        9611492  73908   9049344   1% /var
# /dev/sda4      290208808     28 275393908   1% /nas

# about
#
_about_="disk free probe for mrtg"

# version
#
_version_="2023.09.04"

# github
#
_github_="https://github.com/blue-sky-r/blob/main/alpine-linux/mrtg/usr/bin/mrtg-probe-df.sh"

# default mount-point
#
mp='/'

# usage help
#
[ "$1" == "-h" ] && cat <<< """
= $_about_ = ver $_version_ =

usage: $0 [-h] [-d] [[mount1] [mount2]]

-h    ... show this usage help
-d    ... additional debug info
mount1   ... mount point I (default $mp)
mount2   ... mount point O (default $mp)

$_github_
""" && exit 1

# optional debug
#
[ "$1" == "-d" ] && DBG=1 && shift

# df
#
MOUNTI=${1:-$mp}
[ $DBG ] && echo -n "DBG.I: mount-point[$MOUNTI] "
df | awk '/'${MOUNTI//\//\\/}'$/ {print 1024*$4}'

# df
#
MOUNTO=${2:-$mp}
[ $DBG ] && echo -n "DBG.O: mount-point[$MOUNTO] "
df | awk '/'${MOUNTO//\//\\/}'$/ {print 1024*$4}'

# Line 3
# 82360.60 163181.37
[ $DBG ] && echo -n "DBG.uptime: "
cat /proc/uptime | awk '{s=$1; d=int(s/86400); s=s%86400; h=int(s/3600); s=s%3600; m=int(s/60); s=s%60; printf "%dd %dh %dm %ds\n",d,h,m,s}'

# Line 4
#
[ $DBG ] && echo -n "DBG.host: "
echo $HOSTNAME
