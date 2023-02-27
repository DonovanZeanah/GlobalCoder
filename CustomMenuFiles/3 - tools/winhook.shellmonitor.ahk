Gui, +AlwaysOnTop
Gui, Add, Text,, WinHook.Shell
Gui, Add, ListView, r25 w1000, Win_Hwnd|Win_Title|Win_Class|Win_Exe|Win_Event
Gui, Show

WinHook.Shell.Add("AllShell") ; no additional filter parameters result in all windows

AllShell(Win_Hwnd, Win_Title, Win_Class, Win_Exe, Win_Event)
{
	LV_Insert(1, "", Win_Hwnd, Win_Title, Win_Class, Win_Exe, Win_Event)
	Loop, 5
		LV_ModifyCol(A_Index, "AutoHdr")
}

return
GuiClose:
ExitApp
