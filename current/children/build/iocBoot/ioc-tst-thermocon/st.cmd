#!/reg/g/pcds/epics-dev/rsmm97/ioc/tmo/thermocon/current/bin/rhel7-x86_64/thermocon

< envPaths
epicsEnvSet( "ENGINEER" , "Ricardo Martinez (rsmm97)" )
epicsEnvSet( "IOCSH_PS1", "ioc-tst-thermocon>" )
epicsEnvSet( "IOC_PV",    "TST"   )
epicsEnvSet( "LOCATION",  "Somewhere Over the Rainbow")
epicsEnvSet( "IOCTOP",    "/reg/g/pcds/epics-dev/rsmm97/ioc/tmo/thermocon/current"   )
epicsEnvSet( "TOP",       "/reg/g/pcds/epics-dev/rsmm97/ioc/tmo/thermocon/current/children/build"      )

cd( "$(IOCTOP)" )

# Run common startup commands for linux soft IOC's
< /reg/d/iocCommon/All/pre_linux.cmd

# Register all support components
dbLoadDatabase("dbd/thermocon.dbd")

thermocon_registerRecordDeviceDriver(pdbbase)

# Set this to enable LOTS of stream module diagnostics
#var streamDebug 1

# Configure each device

drvAsynIPPortConfigure( "THERMOCON0", "172.21.148.33:502 TCP", 0, 0, 1 )
modbusInterposeConfig("THERMOCON0",0,5000,0)

# Register definitions are From Setra modbus datasheet go as followed
#
# Setra$(N)_set_reg-  Writes to device a register #8000. Used to read snapshot of Setra_read_register records.
#
# Setra$(N)_samp_reg- ReadWrite device registers #5000-#5032.
#
# Setra$(N)_read_reg- ReadWrite device registers #9000-#9085. 
 

# drvModbusAsynConfigure(modbusPort,  asynPort,  slave address, modbus_function, offset, data_length,
#                        data_type, timeout, debug name)

#drvModbusAsynConfigure(  "Setra0_set_reg",  "THERMOCON0",  1,  16,  8000,   4,  0,  1000, "THERMOCON0_Set")
#drvModbusAsynConfigure(  "Setra0_samp_reg", "THERMOCON0",  1,  16,  5000,  32,  0,  1000, "THERMOCON0_Samp")
#drvModbusAsynConfigure(  "Setra0_read_reg", "THERMOCON0",  1,   3,  9000,  85,  0,  3000, "THERMOCON0_Read")


drvModbusAsynConfigure(  "THERMOCON0_read_reg", "THERMOCON0",  1,   3,  0x0040,  6,  0,  3000, "THERMOCON0_Read")
drvModbusAsynConfigure(  "THERMOCON0_set_reg", "THERMOCON0",  1,   6,  0x0050,  1,  0,  3000, "THERMOCON0_set")

# USED AS DEBUGGING TOOL
#asynSetTraceMask("Setra0_set_reg", 0, 9)
#asynSetTraceMask("Setra0_read_register", 0, 9)
#asynSetTraceIOMask("THERMOCON0", 0, 4)
#asynSetTraceMask("THERMOCON0", 0, 9) 

# Send trace output to motor specific log files
#asynSetTraceFile(   "THERMOCON0", 0, "/reg/d/iocData/$(IOC)/logs/THERMOCON0.log" )
#asynSetTraceFile(   "THERMOCON0_Read", 0, "/reg/d/iocData/$(IOC)/logs/THERMOCON0_Read.log" )

# Load record instances

dbLoadRecords( "db/iocSoft.db",            "IOC=$(IOC_PV)" )
dbLoadRecords( "db/save_restoreStatus.db", "P=$(IOC_PV):" )
dbLoadRecords( "db/thermocon.db",       "DEV=TST,N=0" )
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



