Gui, +AlwaysOnTop
Gui, Add, Text,, WinHook.Event
Gui, Add, ListView, r25 w1000, hWinEventHook|Event|hWnd|idObject|idChild|dwEventThread|dwmsEventTime|wTitle|wClass
Gui, Show

WinHook.Event.Add(0x0000, 0xFFFF, "AllEvent") ; 0x0000 to 0xFFFF is all events, also with no process specified it defaults to all processes.

AllEvent(hWinEventHook, event, hwnd, idObject, idChild, dwEventThread, dwmsEventTime)
{
	WinGetTitle, wTitle, ahk_id %Hwnd%
	WinGetClass, wClass, ahk_id %Hwnd%
	LV_Insert(1, "", hWinEventHook, event, hwnd, idObject, idChild, dwEventThread, dwmsEventTime, wTitle, wClass)
	Loop, 9
		LV_ModifyCol(A_Index, "AutoHdr")
}

return
GuiClose:
ExitApp
