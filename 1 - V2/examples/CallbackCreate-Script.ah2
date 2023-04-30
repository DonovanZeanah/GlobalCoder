EnumAddress := CallbackCreate(EnumWindowsProc, "Fast")  ; Fast-mode is okay because it will be called only from this thread.

DetectHiddenWindows True  ; Due to fast-mode, this setting will go into effect for the callback too.

; Pass control to EnumWindows(), which calls the callback repeatedly:
DllCall("EnumWindows", "Ptr", EnumAddress, "Ptr", 0)
MsgBox Output  ; Display the information accumulated by the callback.
    
EnumWindowsProc(hwnd, lParam)
{
    global Output
    win_title := WinGetTitle(hwnd)
    win_class := WinGetClass(hwnd)
    if win_title
        Output .= "HWND: " hwnd "`tTitle: " win_title "`tClass: " win_class "`n"
    return true  ; Tell EnumWindows() to continue until all windows have been enumerated.
}