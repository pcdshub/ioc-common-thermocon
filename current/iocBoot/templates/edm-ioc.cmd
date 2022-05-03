#! /bin/bash

# Setup the common directory env variables
if [ -e      /reg/g/pcds/pyps/config/common_dirs.sh ]; then
	source   /reg/g/pcds/pyps/config/common_dirs.sh
elif [ -e    /afs/slac/g/pcds/pyps/config/common_dirs.sh ]; then
	source   /afs/slac/g/pcds/pyps/config/common_dirs.sh
fi

# Setup edm environment
source /reg/g/pcds/pyps/conda/py36env.sh

pushd $$IOCTOP/thermoconScreens

$$LOOP(THERMOCON)
export IOC_PV=$$IOC_PV
export BASE=$$BASE

pydm -m "DEV=${BASE},IOC=${IOC_PV}" thermocon.ui &
$$ENDLOOP(THERMOCON)
