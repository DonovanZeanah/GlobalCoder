OnMessage 0x5555, MsgMonitor
Persistent

MsgMonitor(wParam, lParam, msg, *)
{
    ; Since returning quickly is often important, it is better to use ToolTip than
    ; something like MsgBox that would prevent the function from finishing:
    ToolTip "Message " msg " arrived:`nWPARAM: " wParam "`nLPARAM: " lParam
}

; The following could be used inside some other script to run the function inside the above script:
SetTitleMatchMode 2
DetectHiddenWindows True
if WinExist("Name of Receiving Script.ahk ahk_class AutoHotkey")
    PostMessage 0x5555, 11, 22  ; The message is sent  to the "last found window" due to WinExist above.
DetectHiddenWindows False  ; Must not be turned off until after PostMessage.