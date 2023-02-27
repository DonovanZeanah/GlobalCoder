; Array of Objects
devicesConnected := Array()
For device in ComObjGet("winmgmts:").ExecQuery("Select * from Win32_PnPEntity")
	devicesConnected.Push({DeviceID: device.DeviceID, DeviceStatus: device.Status})

; loop through array of items and then loop through each element of item 
for Index, Device in devicesConnected
	for Item, Value in Device.OwnProps() ; <-- Objects are more primitive without enumerators so one needs to be created with OwnProps() 
		MsgBox Item "`t" Value

; loop through array of items and then access each element of the item statically
for Index, Device in devicesConnected
	MsgBox Device.DeviceID "`t" Device.DeviceStatus

; Array of Maps
devicesConnected := Array()
For device in ComObjGet("winmgmts:").ExecQuery("Select * from Win32_PnPEntity")
        devicesConnected.Push(Map('DeviceID', device.DeviceID , 'DeviceStatus', device.Status))

; loop through array of items and then loop through each element of item 
for Index, Device in devicesConnected
	for Item, Value in Device
		MsgBox Item "`t" Value

; loop through array of items and then access each element of the item statically
for Index, Device in devicesConnected
	MsgBox Device["DeviceID"] "`t" Device["DeviceStatus"] ; <-- Map static [""] syntax is a little more clunky than . but dynamic Map[Var] vs Object.%Var% the map seems cleaner
