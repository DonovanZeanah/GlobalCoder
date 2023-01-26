#NoEnv                            ; For performance & future compatibility
#Warn                             ; For catching common errors
SendMode Input                    ; For superior speed and reliability
SetWorkingDir %A_ScriptDir%       ; Ensures a consistent starting directory
; ===========================  Initial Settings  ===============================
Menu, ContextMenu, add,  Menu&1, MenuHandler
Menu, ContextMenu, add,  Menu&2, MenuHandler
Menu, NewMenu, add, New Sub 1, MenuHandler
Menu, NewMenu, add, New Sub 2, MenuHandler
Menu, ContextMenu, Add, &New Menu, :NewMenu
OnMessage(0x0122,"WM_MENURBUTTONUP"), OnMessage(0x211,"WM_ENTERMENULOOP"), rbc=0
return

CapsLock::
rbc:=0, Menu_Show(MenuGetHandle("ContextMenu"), A_ScriptHwnd) ; Can select menu
return                            ;   with both the left and right mouse buttons.

MenuHandler:
MsgBox,% "Menu:`t" A_ThisMenu "`n"
      .  "Item:`t" A_ThisMenuItem "`n"
      .  "Button:`t" (rbc ? "Right" : "Left")
return

WM_MENURBUTTONUP(wparam, lparam)
{ local w
  MouseGetPos,,, w
  ControlSend,, {enter}, ahk_id %w%
  rbc:=1
}
WM_ENTERMENULOOP() ; Notifies an application's main window procedure that a
{ return true ; menu modal loop has been entered. By returning true, AHK
} ; doesn't halt processing Messages, timers, hotkeys... (the default behavior)

Menu_Show(hMenu, hWnd=0, mX="", mY="", Flags=0x1) ; goo.gl/fRwDwG
{ local p, a=VarSetCapacity(p,8,0), b=DllCall("GetCursorPos", UInt,&p)
  DetectHiddenWindows On
  WinActivate ahk_id %hWnd%
  Return DllCall("TrackPopupMenu",UInt,hMenu,UInt,Flags, Int,mX=""?NumGet(p,0):mX
  , Int,mY=""?NumGet(p,4):mY, UInt,0, UInt,hWnd?hWnd:WinActive("A"), UInt,0)
} ; goo.gl/CosNig; Flags: TPM_RECURSE=0x1, TPM_RETURNCMD=0x100, TPM_NONOTIFY=0x80

F4::ExitApp
F5::Reload