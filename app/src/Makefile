TOP=../..

include $(TOP)/configure/CONFIG
#----------------------------------------
#  ADD MACRO DEFINITIONS AFTER THIS LINE
#=============================

#=============================
# Build an ioc application
# Use PROD_IOC_RTEMS for RTEMS only
# Use PROD_IOC_Linux for Linux only
PROD_IOC_Linux = thermocon

# thermocon.dbd will be created and installed
DBD += thermocon.dbd

thermocon_DBD += base.dbd
thermocon_DBD += iocAdmin.dbd
thermocon_DBD += asSupport.dbd
thermocon_DBD += asyn.dbd
#thermocon_DBD += stream.dbd
thermocon_DBD += modbus.dbd
thermocon_DBD += modbusSupport.dbd
thermocon_DBD += caPutLog.dbd

# <name>_registerRecordDeviceDriver.cpp will be created from <name>.dbd
thermocon_SRCS += thermocon_registerRecordDeviceDriver.cpp
thermocon_SRCS_DEFAULT += thermoconMain.cpp

# Add locally compiled object code
#thermocon_SRCS += dbSubExample.c

#thermocon_LIBS += stream
#thermocon_LIBS += calc

thermocon_LIBS += autosave
thermocon_LIBS += devIocStats
thermocon_LIBS += modbus
thermocon_LIBS += caPutLog
thermocon_LIBS += asyn
thermocon_LIBS += $(EPICS_BASE_IOC_LIBS)

#===========================

include $(TOP)/configure/RULES
#----------------------------------------
#  ADD RULES AFTER THIS LINE

