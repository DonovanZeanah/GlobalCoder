;https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-registershellhookwindow

; ----------------------------------------------
; ------------- SHELL HOOK EXAMPLE -------------
; ----------------------------------------------
; 1   HSHELL_WINDOWCREATED
; 2   HSHELL_WINDOWDESTROYED
; 3   HSHELL_ACTIVATESHELLWINDOW
; 4   HSHELL_WINDOWACTIVATED
; 5   HSHELL_GETMINRECT
; 6   HSHELL_REDRAW
; 7   HSHELL_TASKMAN
; 8   HSHELL_LANGUAGE
; 9   HSHELL_SYSMENU
; 10  HSHELL_ENDTASK
; 11  HSHELL_ACCESSIBILITYSTATE
; 12  HSHELL_APPCOMMAND
; 13  HSHELL_WINDOWREPLACED
; 14  HSHELL_WINDOWREPLACING
; 15  HSHELL_HIGHBIT
; 16  HSHELL_FLASH
; 17  HSHELL_RUDEAPPACTIVATED

DllCall("RegisterShellHookWindow", "ptr", A_ScriptHwnd)
MsgNum := DllCall("RegisterWindowMessage", "Str", "SHELLHOOK")
OnMessage(MsgNum, "ShellMessage")
Return
global str_list
str_list := ""

ShellMessage(wParam, lParam)
{
    WinGet, exe, ProcessName, Ahk_id %lParam%
    str_list .= "type:" Bin(wParam) " ID: " lParam " : " exe "`n"
}

f1::
    MsgBox, % str_list
    str_list := ""
Return

Bin(x){
    while x
        r:=1&x r,x>>=1
    return r
}

;basically on events such as the browser closing it will trigger a message
;you can check on message see if it's the browser closing
;if so take action
;this is a demo script that you can use to see messages
;run the script
;open and close some windows
;then press F1
;you should see a list of events