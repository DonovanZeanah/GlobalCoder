MouseMoveHandler := 
    callback: () => {
        MsgBox You moved the mouse.
    }


; Register the MouseMoveHandler function to handle the mouse move event
OnEvent("MouseMove", "MouseMoveHandler.callback")

; Wait for user input
InputBox("user_input", "Enter some text:")

; Display the user input
MsgBox ("You entered %user_input%.")




; Set environment/system variables
/*EnvSet("JAVA_HOME", "my_value") ; Set an environment variable
RegWriteString("HKEY_LOCAL_MACHINE", "SYSTEM\CurrentControlSet\Control\Session Manager\Environment", "MY_VARIABLE", "my_value") ; Set a system variable

; Display the value of the variables
MsgBox "Environment variable MY_VARIABLE is set to: " . EnvGet("MY_VARIABLE")
MsgBox "System variable MY_VARIABLE is set to: " . RegReadString("HKEY_LOCAL_MACHINE", "SYSTEM\CurrentControlSet\Control\Session Manager\Environment", "MY_VARIABLE")

; Function to set an environment variable
EnvSet(name, value) {
    EnvSet, %name%, %value%
}

; Function to set a system variable
RegWriteString(rootkey, subkey, name, value) {
    reg := RegOpenKeyEx(rootkey, subkey, KEY_SET_VALUE)
    RegWrite(reg, name, value, "REG_SZ")
    RegCloseKey(reg)
}
*/