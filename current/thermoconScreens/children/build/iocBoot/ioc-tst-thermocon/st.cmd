#!/reg/g/pcds/epics-dev/janezg/thermocon/current/bin/rhel7-x86_64/thermocon

< envPaths
epicsEnvSet( "ENGINEER" , "Janez Govednik (janezg)" )
epicsEnvSet( "IOCSH_PS1", "ioc-tst-thermocon>" )
epicsEnvSet( "IOC_PV",    "IOC:TST"   )
epicsEnvSet( "LOCATION",  "Somewhere Over the Rainbow")
epicsEnvSet( "IOCTOP",    "/reg/g/pcds/epics-dev/janezg/thermocon/current"   )
epicsEnvSet( "TOP",       "/reg/g/pcds/epics-dev/janezg/thermocon/current/children/build"      )

cd( "$(IOCTOP)" )

# Run common startup commands for linux soft IOC's
< /reg/d/iocCommon/All/pre_linux.cmd

# Register all support components
dbLoadDatabase("dbd/thermocon.dbd")

thermocon_registerRecordDeviceDriver(pdbbase)

# Set this to enable LOTS of stream module diagnostics
#var streamDebug 1

# Configure each device

drvAsynIPPortConfigur ( "THERMOCON0", "ser-tmo-XX:4001 TCP", 0, 0, 1 )
modbusInterposeConfig ( "THERMOCON0", 0, 5000, 0 )

# drvModbusAsynConfigure(modbusPort,  asynPort,  slave address, modbus_function, offset, data_length,
#                        data_type, timeout, debug name)

drvModbusAsynConfigure(  "THERMOCON0_read_reg", "THERMOCON0",  1,   3,  0x0040,  6,  0,  3000, "THERMOCON0_Read")
drvModbusAsynConfigure(  "THERMOCON0_set_reg", "THERMOCON0",  1,   6,  0x0050,  1,  0,  3000, "THERMOCON0_set")

# USED AS DEBUGGING TOOL
#asynSetTraceIOMask("THERMOCON0", 0, 4)
#asynSetTraceMask("THERMOCON0", 0, 9) 

# Send trace output to motor specific log files
#asynSetTraceFile(   "THERMOCON0", 0, "/reg/d/iocData/$(IOC)/logs/THERMOCON0.log" )
#asynSetTraceFile(   "THERMOCON0_Read", 0, "/reg/d/iocData/$(IOC)/logs/THERMOCON0_Read.log" )

# Load record instances

dbLoadRecords( "db/iocSoft.db",            "IOC=$(IOC_PV)" )
dbLoadRecords( "db/save_restoreStatus.db", "P=$(IOC_PV):" )
dbLoadRecords( "db/thermocon.db",       "DEV=TST:TMO,N=0" )
#dbLoadRecords( "db/asynRecord.db", "Dev=NAME, PORT=PORT")

# Setup autosave
set_savefile_path( "$(IOC_DATA)/$(IOC)/autosave")
set_requestfile_path( "$(TOP)/autosave")
save_restoreSet_status_prefix( "$(IOC_PV)" )
save_restoreSet_IncompleteSetsOk( 1 )
save_restoreSet_DatedBackupFiles( 1 )

# Just restore the settings
set_pass0_restoreFile( "$(IOC).sav" )
set_pass1_restoreFile( "$(IOC).sav" )

# Initialize the IOC and start processing records
iocInit()

# Start autosave backups
create_monitor_set( "$(IOC).req", 5, "" )

# All IOCs should dump some common info after initial startup.
< /reg/d/iocCommon/All/post_linux.cmd



