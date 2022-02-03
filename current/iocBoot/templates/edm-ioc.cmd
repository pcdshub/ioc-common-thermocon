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

$$LOOP(THERMOCON)
export IOC_PV=$$IOC_PV
export BASE=$$BASE

pushd $$IOCTOP
#edm -x -eolc	\
#	-m "IOC=${IOC_PV}"		\
#       -m "BASE=${BASE}"               \
#	thermoconScreens/thermocon.edm &
echo 'No screens for $$BASE!!'
$$ENDLOOP(THERMOCON)
