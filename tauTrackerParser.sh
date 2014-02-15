#!/bin/bash

rollDetail=off
logFile=shivehRollCall.log

usage="RollCall Parser\n\n
Usage:\n\t"$0" -f rollCall.log -d\n
\nOptions:\n
\t-f,--file\tRollCall Log File[Default: ~/rollCall.log]\n
\t-d,--detail\tShow Detail\n
\t-h,--help\tPrints this Message & Exits\n"

while [ $# -gt 0 ]
do
    case $1 in
	--help|-h) echo -e ${usage};
	    exit;;
	--detial|-d) rollDetail=on;;
	--file|-f) logFile=$2;;
    esac
    shift
done
cd ~

if [ ! -e "${logFile}" ]
then
    echo "Log File Not Found!"
    exit
fi
echo 'here'
clear

errors=0
total=''
tH=0
tM=0
prefixStart="STARTED"
prefixEnd="ENDED"

started=""
ended=""
while read line
do
started=${ended}
ended=${line}
if [ "${started}" = "" ] || [ "${ended}" = "" ]
then
    continue
fi

msg='Due: '
sPrefix=${started%%@*}
ePrefix=${ended%%@*}
if [ ${sPrefix} != ${prefixStart} ] || [ ${ePrefix} != ${prefixEnd} ]
then
    let "errors=${errors} + 1"
    continue
fi

if [ ${rollDetail} = on ]
then
    echo ${started}
    echo ${ended}
fi

s=${started##*@}
e=${ended##*@}
sD=$(date +%-d -d "${s}")
sH=$(date +%-H -d "${s}")
sM=$(date +%-M -d "${s}")
eD=$(date +%-d -d "${e}")
eH=$(date +%-H -d "${e}")
eM=$(date +%-M -d "${e}")
let "dH=${eH} - ${sH}"
let "dM=60 - ${sM} + ${eM}"
let "d_M=${dM} % 60"
let "dd_M=${dM} - ${d_M}"
let "dd_M=${dd_M} / 60"
let "dH=${dH} + ${dd_M} - 1"
let "dM=${d_M}"

let "tH=${tH} + ${dH}"
let "tM=${tM} + ${dM}"

dayOfWeek=$(date +%u -d "${s}")
let "dayOfWeek=${dayOfWeek} + 1"
let "dayOfWeek=${dayOfWeek} % 7"
dayOfWeekName=$(date +%A -d "${s}")
if [ ${rollDetail} = on ]
then
    echo "["${dayOfWeek}"] "${dayOfWeekName}
fi

msg=${msg}${dH}":"${dM}
if [ ${rollDetail} = on ]
then
    echo ${msg}
    echo
fi

done < "${logFile}"

let "t_M=${tM} % 60"
let "dt_M=${tM} - ${t_M}"
let "dt_M=${dt_M} / 60"
let "tH=${tH} + ${dt_M}"
let "tM=${t_M}"

total=${tH}":"${tM}

echo '+================+'
echo '| Errors: '${errors}
echo '|'
echo '| Total:  '${total}
echo '+================+'
echo
exit 0
