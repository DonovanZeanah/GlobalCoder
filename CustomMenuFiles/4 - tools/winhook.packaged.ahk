WinHook.Shell.Add(ObjBindMethod(Excel.Shell, "Button"),,, "EXCEL.EXE",1) ; Excel Window Created

Esc::ExitApp

;{ Excel Call Functions
class Excel
{
	class Shell
	{
		Button(Win_Hwnd, Win_Title, Win_Class, Win_Exe, Win_Event) ; Create Button
		{
			static Button
			; ----- Create WinHook.Event to handle button location with Resize method
			WinGet, PID, PID, ahk_id %Win_Hwnd%
			WinHook.Event.Add(0x800B, 0x800B, ObjBindMethod(Excel.Event, "Resize"), PID, "ahk_id " Win_Hwnd) ; LOCATIONCHANGE
			;~ WinHook.Event.Add(0x000B, 0x000B, ObjBindMethod(Excel.Event, "Resize"), PID, "ahk_id " Win_Hwnd) ; MOVESIZEEND
			; -----
			WinGetPos,,, Win_W, Win_H, ahk_id %Win_Hwnd%
			Gui_X := Win_W - 45 - 49 ; Exact numbers and scaling effected by screen DPI
			Gui_Y := Win_H - 60 - 34 ; Exact numbers and scaling effected by screen DPI
			; Gui Create
			Gui Excel:Default
			Gui +Resize
			Gui, Font, s12, Bold Verdana
			Gui, Margin, 0, 0
			Gui, Add, Button, xp yp Default HWNDButton gButton, Click
			Gui, +LastFound +ToolWindow +AlwaysOnTop -Caption -Border HWNDGui_Hwnd
			Excel.Gui_Hwnd := Gui_Hwnd ; Assign to Class variable to allow access from other Methods
			DllCall("SetParent", "uint", Gui_Hwnd, "uint", Win_Hwnd)
			Gui, Show, x%Gui_X% y%Gui_Y%
			return
			; Gui Actions
			Button:
				MsgBox Clicked
			return
			ExcelGuiSize:
				Excel.Gui_W := A_GuiWidth ; Assign to Class variable to allow access from other Methods
				Excel.Gui_H := A_GuiHeight ; Assign to Class variable to allow access from other Methods
				GuiControl, Move, %Button%, % "W" Excel.Gui_W " H" Excel.Gui_H
			return
		}
	}
	class Event
	{	
		Resize(hWinEventHook, event, hwnd, idObject, idChild, dwEventThread, dwmsEventTime)
		{
			WinGetPos,,, Win_W, Win_H, ahk_id %hwnd%
			Gui_X := Win_W - 45 - Excel.Gui_W
			Gui_Y := Win_H - 60 - Excel.Gui_H
			WinMove, % "ahk_id " Excel.Gui_Hwnd,, Gui_X, Gui_Y
			return
		}
	}
}
;}
