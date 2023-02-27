; Map Only
devicesConnected := Map()
For device in ComObjGet("winmgmts:").ExecQuery("Select * from Win32_PnPEntity")
	devicesConnected[device.DeviceID] := device.Status

for DeviceID, DeviceStatus in devicesConnected
	MsgBox DeviceID "`t" DeviceStatus
