#SingleInstance
OnMessage 0x004A, Receive_WM_COPYDATA  ; 0x004A is WM_COPYDATA
Persistent

Receive_WM_COPYDATA(wParam, lParam, msg, hwnd)
{
    StringAddress := NumGet(lParam, 2*A_PtrSize, "Ptr")  ; Retrieves the CopyDataStruct's lpData member.
    CopyOfData := StrGet(StringAddress)  ; Copy the string out of the structure.
    ; Show it with ToolTip vs. MsgBox so we can return in a timely fashion:
    ToolTip A_ScriptName "`nReceived the following string:`n" CopyOfData
    return true  ; Returning 1 (true) is the traditional way to acknowledge this message.
}