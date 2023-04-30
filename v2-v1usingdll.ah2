

dll := "C:\Users\donov\source\repos\AutoHotkey\bin\AutoHotkey64.dll"
if !hmod := DllCall("LoadLibrary", "str", dll, "ptr")
    throw OSError()
DllCall(dll "\Host", "ptr*", Lib := ComValue(9, 0), "hresult")