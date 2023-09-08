#!$$IOCTOP/bin/$$IF(ARCH,$$ARCH,linux-x86_64)/thermocon

< envPaths
epicsEnvSet( "ENGINEER" , "$$ENGINEER" )
epicsEnvSet( "IOCSH_PS1", "$$IOCNAME>" )
epicsEnvSet( "IOC_PV",    "$$IOC_PV"   )
epicsEnvSet( "LOCATION",  "$$IF(LOCATION,$$LOCATION,$$IOC_PV)")
epicsEnvSet( "IOCTOP",    "$$IOCTOP"   )
epicsEnvSet( "TOP",       "$$TOP"      )

cd( "$(IOCTOP)" )

# Run common startup commands for linux soft IOC's
< /reg/d/iocCommon/All/pre_linux.cmd

# Register all support components
dbLoadDatabase("dbd/thermocon.dbd")
thermocon_registerRecordDeviceDriver(pdbbase)

# Configure each device

$$LOOP(THERMOCON)
drvAsynIPPortConfigure( "THERMOCON$$INDEX", "$$HOST:$$PORT TCP", 0, 0, 0 )
asynOctetSetOutputEos( "THERMOCON$$INDEX", 0, "\r\n" )
asynOctetSetInputEos ( "THERMOCON$$INDEX", 0, "\r\n" )
modbusInterposeConfig( "THERMOCON$$INDEX", 2, 2000, 0)
$$ENDLOOP(THERMOCON)

# drvModbusAsynConfigure(modbusPort,  asynPort,  slave address, modbus_function, offset, data_length,
#                        data_type, timeout, debug name)

$$LOOP(THERMOCON)
drvModbusAsynConfigure(  "THERMOCON$$(INDEX)_read_reg" , "THERMOCON$$INDEX",  1,   3,  64,  7,  0,  2000, "THERMOCON$$(INDEX)_Read"    )
drvModbusAsynConfigure(  "THERMOCON$$(INDEX)_read_ctrl", "THERMOCON$$INDEX",  1,   3,  80,  2,  0,  2000, "THERMOCON$$(INDEX)_ReadCtrl")
drvModbusAsynConfigure(  "THERMOCON$$(INDEX)_set_ctrl" , "THERMOCON$$INDEX",  1,   6,  80,  1,  0,  2000, "THERMOCON$$(INDEX)_SetCtrl" )
drvModbusAsynConfigure(  "THERMOCON$$(INDEX)_set_temp" , "THERMOCON$$INDEX",  1,   6,  81,  1,  0,  2000, "THERMOCON$$(INDEX)_SetTemp" )

# USED AS DEBUGGING TOOL
#asynSetTraceIOMask("THERMOCON$$INDEX", 0, 0x6)
#asynSetTraceMask("THERMOCON$$INDEX", 0, 0x9) 

# Send trace output to motor specific log files
#asynSetTraceFile(   "THERMOCON$$INDEX", 0, "/reg/d/iocData/$(IOC)/logs/THERMOCON$$INDEX.log" )
#asynSetTraceFile(   "THERMOCON$$(INDEX)_Read", 0, "/reg/d/iocData/$(IOC)/logs/THERMOCON$$(INDEX)_Read.log" )
$$ENDLOOP(THERMOCON)

# Load record instances

dbLoadRecords( "db/iocSoft.db",            "IOC=$(IOC_PV)" )
dbLoadRecords( "db/save_restoreStatus.db", "P=$(IOC_PV):" )
$$LOOP(THERMOCON)
dbLoadRecords( "db/thermocon.db",       "DEV=$$BASE,N=$$(INDEX)" )
#dbLoadRecords( "db/asynRecord.db", "Dev=NAME, PORT=PORT")
$$ENDLOOP(THERMOCON)

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



