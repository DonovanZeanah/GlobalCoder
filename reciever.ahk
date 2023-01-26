#SingleInstance
OnMessage(0x004A, "Receive_WM_COPYDATA")  ; 0x004A is WM_COPYDATA
return

Receive_WM_COPYDATA(wParam, lParam)
{
    StringAddress := NumGet(lParam + 2*A_PtrSize)  ; Retrieves the CopyDataStruct's lpData member.
    CopyOfData := StrGet(StringAddress)  ; Copy the string out of the structure.
    ; Show it with ToolTip vs. MsgBox so we can return in a timely fashion:
    ToolTip %A_ScriptName%`nReceived the following string:`n%CopyOfData%
    return true  ; Returning 1 (true) is the traditional way to acknowledge this message.
}