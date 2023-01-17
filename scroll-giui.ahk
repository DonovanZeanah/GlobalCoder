DetectHiddenWindows, On
Gui, 1:+LastFound +0x200000 +Resize +0x2000000
hGui := WinExist()
Gui, 1:Add, Edit, r2 w150 , Edit 1
Gui, 1:Add, Edit, r2 w150 , Edit 2
Gui, 1:Add, Edit, r2 w150 , Edit 3
Gui, 1:Add, Edit, r2 w150 , Edit 4
Gui, 1:Add, Edit, ym r2 w150 , Edit 5
Gui, 1:Add, Edit, r2 w150 , Edit 6
Gui, 1:Add, Edit, r2 w150 , Edit 7
Gui, 1:Add, Edit, r2 w150 , Edit 8
Gui, 1:Add, Button, gGo, Go
Gui, 1:Show, Hide
ScrollInit() 
Gui, 1:Show, h100	
Return

ScrollInit() {
	Global
	VarSetCapacity(SCROLLBAR_INFO, 28, 0)   ;Allocate SCROLLBAR_INFO structure and zero it
	NumPut(28, &SCROLLBAR_INFO)         ;Initialize its count-bytes parameter
	NumPut(0x17, &SCROLLBAR_INFO + 4)      ;Initialize the mask for what properties to get or set, SIF_ALL = 0x17
	SetScrollBar(hGui, 0, 100, 10, 0)
	C_Create(1)
	GuiWinProc := RegisterCallback("GuiWindowProc", ""  ; "" to avoid fast-mode for subclassing.
		 , 4, hGui)  ; Must specify exact ParamCount when EventInfo parameter is present.
	GuiWinProcOld := DllCall("SetWindowLong", UInt, hGui, Int, -4  ; -4 is GWL_WNDPROC
		 , Int, GuiWinProc, UInt)  ; Return value must be set to UInt vs. Int.
	ConWinProc := RegisterCallback("ConWinProc", ""  ; "" to avoid fast-mode for subclassing.
		 , 4, hGui)  ; Must specify exact ParamCount when EventInfo parameter is present.
	ConWinProcOld := DllCall("SetWindowLong", UInt, hContainer, Int, -4  ; -4 is GWL_WNDPROC
		 , Int, ConWinProc, UInt)  ; Return value must be set to UInt vs. Int.
	}

C_Create(GuiNum,Height=0,Width=0) {
	global hContainer, Container
	Gui %GuiNum%:+LastFound
	hGui := WinExist()
	If !Height && !Width 
		WinGetPos,,, Width, Height, ahk_id %hGui%
	Gui %GuiNum%:Add, Text,x0 y0 h%Height% w%Width% +0x4000000 +0x2000000 hwndhContainer vContainer
	WinGet, CList, ControlListhWnd, ahk_id %hGui%
	;MsgBox % CList
	Loop, Parse, CList, `n
		DllCall("SetParent", "uint", A_LoopField, "uint", hContainer)
	}

GuiSize:

VScrollPixelsPerLine := A_GuiHeight / 100
Return



Esc::ExitApp

ConWinProc(hwnd, uMsg, wParam, lParam) {
	global ConWinProcOld, GuiWinProcOld, GuiWinProc
	;Critical
	OldFormat := A_FormatInteger
	SetFormat, Integer, Hex
	MsgLst := WM_COMMAND := 0x111
	MsgLst .= "," . WM_SYSCOMMAND := 0x112
	uMsg += 0
	SetFormat, Integer, %OldFormat%
	if uMsg in %MsgLst%
		{	
		ReturnVal := DllCall("CallWindowProcA", UInt, GuiWinProcOld, UInt, A_EventInfo, UInt, uMsg, UInt, wParam, UInt, lParam)
		return ReturnVal
		}
	return DllCall("CallWindowProcA", UInt, ConWinProcOld, UInt, hwnd, UInt, uMsg, UInt, wParam, UInt, lParam)
	}

Go:
MsgBox
Return

GuiWindowProc(hwnd, uMsg, wParam, lParam) {
	;Critical
	OldFormat := A_FormatInteger
	SetFormat, Integer, Hex
	global GuiWinProcOld, GuiWinProc, VScrollPixelsPerLine, Container, hContainer
	MsgLst := WM_VSCROLL := 0x115
	uMsg += 0
	SetFormat, Integer, %OldFormat%
	if uMsg in %MsgLst%
		{	
		global hGui      ;Only handle messages for the window we want to scroll
		if (hwnd != hGui)
			return DllCall("CallWindowProcA", UInt, GuiWinProcOld, UInt, hwnd, UInt, uMsg, UInt, wParam, UInt, lParam)

		wParamWordLow := Mod(wParam, 0x10000)
		wParamWordHigh := (wParam - wParamWordLow) / 0x10000

		if (wParamWordLow = 5 or wParamWordLow = 8)      ;SB_THUMBTRACK or SB_ENDSCROLL
			return DllCall("CallWindowProcA", UInt, GuiWinProcOld, UInt, hwnd, UInt, uMsg, UInt, wParam, UInt, lParam)

		QueryScrollBar(hwnd, nMin, nMax, nPage, nPos, nTrackPos)

		if (wParamWordLow = 7)            ;SB_BOTTOM
			a:= "" ; MsgBox, SB_BOTTOM
		else if (wParamWordLow = 6)            ;SB_TOP
			a:= "" ; MsgBox, SB_TOP
		else if (wParamWordLow = 1) {            ;SB_LINEDOWN 
			SetScrollBar(hwnd, nMin, nMax, nPage, NewPos := nPos+1)
			GuiControl,1:Move, Container, % "y" . -NewPos * VScrollPixelsPerLine
			}else if (wParamWordLow = 0) {            ;SB_LINEUP
			SetScrollBar(hwnd, nMin, nMax, nPage, NewPos := nPos-1)
			GuiControl,1:Move, Container, % "y" . -NewPos * VScrollPixelsPerLine
				}else if (wParamWordLow = 3) {            ;SB_PAGEDOWN
			SetScrollBar(hwnd, nMin, nMax, nPage, NewPos := nPos+nPage)
			GuiControl,1:Move, Container, % "y" . -NewPos * VScrollPixelsPerLine
		}else if (wParamWordLow = 2) {            ;SB_PAGEUP
			SetScrollBar(hwnd, nMin, nMax, nPage, NewPos := nPos-nPage)
			GuiControl,1:Move, Container, % "y" . -NewPos * VScrollPixelsPerLine
		}else if (wParamWordLow = 4) {            ;SB_THUMBPOSITION
			SetScrollBar(hwnd, nMin, nMax, nPage, NewPos := wParamWordHigh)
			GuiControl,1:Move, Container, % "y" . -NewPos * VScrollPixelsPerLine
			}
;		ToolTip wParamWordLow = %wParamWordLow%`nContainerY = %ContainerY%`nVScrollPixelsPerLine = %VScrollPixelsPerLine%`nhwnd = %hwnd%`nnMin = %nMin%`nnMax = %nMax%`nnPage = %nPage%`nnPos = %nPos%`nnTrackPos = %nTrackPos% ;`nMsgLst= |%MsgLst%|
		return DllCall("CallWindowProcA", UInt, GuiWinProcOld, UInt, hwnd, UInt, uMsg, UInt, wParam, UInt, lParam)
		}
; Otherwise (since above didn't return), pass all unhandled events to the original WindowProc.
;	SetFormat, Integer, %OldFormat%
	return DllCall("CallWindowProcA", UInt, GuiWinProcOld, UInt, hwnd, UInt, uMsg, UInt, wParam, UInt, lParam)
	}

QueryScrollBar(hwnd, ByRef nMin, ByRef nMax, ByRef nPage, ByRef nPos, ByRef nTrackPos)
{
   ;Win32 API:   BOOL GetScrollInfo( HWND hwnd, int fnBar, LPSCROLLINFO lpsi )

   global SCROLLBAR_INFO

   bSuccess := DllCall("GetScrollInfo", UInt, hwnd, Int, 1, UInt, &SCROLLBAR_INFO)   ;SB_VERT = 1
   if (!bSuccess)
      return false

   nMin := NumGet(&SCROLLBAR_INFO, 8)
   nMax := NumGet(&SCROLLBAR_INFO, 12)
   nPage := NumGet(&SCROLLBAR_INFO, 16)
   nPos := NumGet(&SCROLLBAR_INFO, 20)
   nTrackPos := NumGet(&SCROLLBAR_INFO, 24)

   return true
}
;---------------------------------------------------------------------------------------------------------------
SetScrollBar(hwnd, nMin, nMax, nPage, nPos)
{
   ;Win32 API:   int SetScrollInfo( HWND hwnd, int fnBar, LPCSCROLLINFO lpsi, BOOL fRedraw )

   global SCROLLBAR_INFO
   NumPut(nMin, &SCROLLBAR_INFO + 8)      ;Min
   NumPut(nMax, &SCROLLBAR_INFO + 12)      ;Max
   NumPut(nPage, &SCROLLBAR_INFO + 16)      ;Page
   NumPut(nPos, &SCROLLBAR_INFO + 20)      ;Pos
   iReturnPos := DllCall("SetScrollInfo", UInt, hwnd, Int, 1, UInt, &SCROLLBAR_INFO, Int, true)   ;SB_VERT = 1
   return (iReturnPos == nPos)
}
;---------------------------------------------------------------------------------------------------------------
GuiClose:
   ExitApp
return
;---------------------------------------------------------------------------------------------------------------