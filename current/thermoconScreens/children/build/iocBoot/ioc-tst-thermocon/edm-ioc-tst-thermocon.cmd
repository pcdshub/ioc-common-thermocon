#! /bin/bash

# Setup the common directory env variables
if [ -e      /reg/g/pcds/pyps/config/common_dirs.sh ]; then
	source   /reg/g/pcds/pyps/config/common_dirs.sh
elif [ -e    /afs/slac/g/pcds/pyps/config/common_dirs.sh ]; then
	source   /afs/slac/g/pcds/pyps/config/common_dirs.sh
fi

# Setup edm environment
if [ -f    ${SETUP_SITE_TOP}/epicsenv-cur.sh ]; then
	source ${SETUP_SITE_TOP}/epicsenv-cur.sh
fi

export IOC_PV=IOC:TST
export BASE=TST:TMO

pushd /reg/g/pcds/epics-dev/janezg/thermocon/current
#edm -x -eolc	\
#	-m "IOC=${IOC_PV}"		\
#       -m "BASE=${BASE}"               \
#	thermoconScreens/thermocon.edm &
echo 'No screens for TST:TMO!!'
