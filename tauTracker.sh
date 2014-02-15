#!/bin/bash

#
# tauTacker
#

configFile="/etc/tauTracker/config.sh"
[ -r $configFile ] && source "$configFile"
configFile="~/.tauTracker"
[ -r $configFile ] && source "$configFile"
configFile="./.tauTracker.config"
[ -r $configFile ] && source "$configFile"

roll=/slashsBin/rollLog/roll.log
[ -x ${logFile} ] || `touch ${logFile}`

state=${0:(-1)}
state=${state^^}

echo "[$state]"`date +'%Y-%m-%d: %A%t%t%B%t%t%d%t%Y%t%T %p%t%t'` >> $roll

exit 0
