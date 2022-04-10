#!/bin/bash

# display mrtg target.log file in human readable format

[ $# -lt 1 ] && cat <<< """
Display mrtg target log file with decoded timestamps and segment headers:

usage: $(basename $0) mrtg-target.log
""" && exit 1

awk '
    function interval(ts)
    {
        delta = last - ts
        last = ts
        if (delta == 0)             return "LAST"
        if (delta <= 5 * 60)        return "D 5m"
        if (delta <= 30 * 60)       return "W 30m"
        if (delta <= 2 * 60 * 60)   return "M 2h"
        if (delta <= 24 * 60 * 60)  return "Y 1d"
        return delta
    }

    function printline(line, dt, ts, d, inavg, outavg, inpeak, outpeak)
    {
        printf "%5s - [ %s ] %s %6s \t %12s \t %12s \t %12s \t %12s \n", line, dt, ts, d, inavg, outavg, inpeak, outpeak
    }

    BEGIN { dateformat = "%d.%m.%Y %H:%M:%S" }
    # 1st line header
    NR == 1 { printline("LAST", "dd.mm.yyyy hh:mm:ss", "timestamp", "", "= IN.raw =", "= OUT.raw =", "", ""); last = $1 }
    NR >  1 { rowdesc = interval($1) }
    # 2nd line header
    NR == 2 { printline("LAST", "dd.mm.yyyy hh:mm:ss", "timestamp", "= delta =", "= IN.avg =", "= OUT.avg =", "= IN.peak =", "= OUT.peak =") }
    # D-W-M-Y segment header
    NR >= 4 && lastdesc != rowdesc { printline(rowdesc, "dd.mm.yyyy hh:mm:ss", "timestamp", "= delta =", "= IN.avg =", "= OUT.avg =", "= IN.peak =", "= OUT.peak ="); lastdesc=rowdesc }
    # data
    { printline(NR, strftime(dateformat, $1), $1, delta, $2, $3, $4, $5) }' \
    $1
