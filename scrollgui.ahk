#Requires AutoHotkey v2.0.2
;[edited to make it x64/x32 compatible]
;Scrollable Gui - Proof of Concept - Scripts and Functions - AutoHotkey Community
;https://autohotkey.com/board/topic/26033-scrollable-gui-proof-of-concept/#entry168174
; MK_SHIFT = 0x0004, WM_MOUSEWHEEL = 0x020A, WM_MOUSEHWHEEL = 0x020E, WM_NCHITTEST = 0x0084
Lines := "1`n2`n3`n4`n5`n6`n7`n8`n9`n10"
ScrollGui := Gui("+Resize +0x300000", "Scrollable GUI") ; WS_VSCROLL | WS_HSCROLL
ScrollGui.OnEvent("Size", ScrollGui_Size)
ScrollGui.OnEvent("Close", ScrollGui_Close)
Loop 8
    ScrollGui.AddEdit("r5 w600", Lines)
ScrollGui.AddButton( , "Do absolutely nothing")
ScrollGui.Show("w400 h300")
OnMessage(0x0115, OnScroll) ; WM_VSCROLL
OnMessage(0x0114, OnScroll) ; WM_HSCROLL
OnMessage(0x020A, OnWheel)  ; WM_MOUSEWHEEL
Return
; ======================================================================================================================
ScrollGui_Size(GuiObj, MinMax, Width, Height) {
   If (MinMax != 1)
      UpdateScrollBars(GuiObj)
}
; ======================================================================================================================
ScrollGui_Close(*) {
   ExitApp
}
; ======================================================================================================================
UpdateScrollBars(GuiObj) {
   ; SIF_RANGE = 0x1, SIF_PAGE = 0x2, SIF_DISABLENOSCROLL = 0x8, SB_HORZ = 0, SB_VERT = 1
   ; Calculate scrolling area.
   WinGetClientPos( , , &GuiW, &GuiH, GuiObj.Hwnd)
   L := T := 2147483647   ; Left, Top
   R := B := -2147483648  ; Right, Bottom
   For CtrlHwnd In WinGetControlsHwnd(GuiObj.Hwnd) {
      ControlGetPos(&CX, &CY, &CW, &CH, CtrlHwnd)
      L := Min(CX, L)
      T := Min(CY, T)
      R := Max(CX + CW, R)
      B := Max(CY + CH, R)
   }
   L -= 8, T -= 8
   R += 8, B += 8
   ScrW := R - L ; scroll width
   ScrH := B - T ; scroll height
   ; Initialize SCROLLINFO.
   SI := Buffer(28, 0)
   NumPut("UInt", 28, "UInt", 3, SI, 0) ; cbSize , fMask: SIF_RANGE | SIF_PAGE
   ; Update horizontal scroll bar.
   NumPut("Int", ScrW, "Int", GuiW, SI, 12) ; nMax , nPage
   DllCall("SetScrollInfo", "Ptr", GuiObj.Hwnd, "Int", 0, "Ptr", SI, "Int", 1) ; SB_HORZ
   ; Update vertical scroll bar.
   ; NumPut("UInt", SIF_RANGE | SIF_PAGE | SIF_DISABLENOSCROLL, SI, 4) ; fMask
   NumPut("Int", ScrH, "UInt", GuiH,  SI, 12) ; nMax , nPage
   DllCall("SetScrollInfo", "Ptr", GuiObj.Hwnd, "Int", 1, "Ptr", SI, "Int", 1) ; SB_VERT
   ; Scroll if necessary
   X := (L < 0) && (R < GuiW) ? Min(Abs(L), GuiW - R) : 0
   Y := (T < 0) && (B < GuiH) ? Min(Abs(T), GuiH - B) : 0
   If (X || Y)
      DllCall("ScrollWindow", "Ptr", GuiObj.Hwnd, "Int", X, "Int", Y, "Ptr", 0, "Ptr", 0)
}
; ======================================================================================================================
OnWheel(W, L, M, H) {
   If !(HWND := WinExist()) || GuiCtrlFromHwnd(H)
      Return
   HT := DllCall("SendMessage", "Ptr", HWND, "UInt", 0x0084, "Ptr", 0, "Ptr", l) ; WM_NCHITTEST = 0x0084
   If (HT = 6) || (HT = 7) { ; HTHSCROLL = 6, HTVSCROLL = 7
      SB := (W & 0x80000000) ? 1 : 0 ; SB_LINEDOWN = 1, SB_LINEUP = 0
      SM := (HT = 6) ? 0x0114 : 0x0115 ;  WM_HSCROLL = 0x0114, WM_VSCROLL = 0x0115
      OnScroll(SB, 0, SM, HWND)
      Return 0
   }
}
; ======================================================================================================================
OnScroll(WP, LP, M, H) {
   Static SCROLL_STEP := 10
   Bar := (M = 0x0115) ; SB_HORZ=0, SB_VERT=1
   SI := Buffer(28, 0)
   NumPut("UInt", 28, "UInt", 0x17, SI) ; cbSize, fMask: SIF_ALL
   If !DllCall("GetScrollInfo", "Ptr", H, "Int", Bar, "Ptr", SI)
      Return
   RC := Buffer(16, 0)
   DllCall("GetClientRect", "Ptr", H, "Ptr", RC)
   NewPos := NumGet(SI, 20, "Int") ; nPos
   MinPos := NumGet(SI,  8, "Int") ; nMin
   MaxPos := NumGet(SI, 12, "Int") ; nMax
   Switch (WP & 0xFFFF) {
      Case 0: NewPos -= SCROLL_STEP ; SB_LINEUP
      Case 1: NewPos += SCROLL_STEP ; SB_LINEDOWN
      Case 2: NewPos -= NumGet(RC, 12, "Int") - SCROLL_STEP ; SB_PAGEUP
      Case 3: NewPos += NumGet(RC, 12, "Int") - SCROLL_STEP ; SB_PAGEDOWN
      Case 4, 5: NewPos := WP >> 16 ; SB_THUMBTRACK, SB_THUMBPOSITION
      Case 6: NewPos := MinPos ; SB_TOP
      Case 7: NewPos := MaxPos ; SB_BOTTOM
      Default: Return
   }
   MaxPos -= NumGet(SI, 16, "Int") ; nPage
   NewPos := Min(NewPos, MaxPos)
   NewPos := Max(MinPos, NewPos)
   OldPos := NumGet(SI, 20, "Int") ; nPos
   X := (Bar = 0) ? OldPos - NewPos : 0
   Y := (Bar = 1) ? OldPos - NewPos : 0
   If (X || Y) {
      ; Scroll contents of window and invalidate uncovered area.
      DllCall("ScrollWindow", "Ptr", H, "Int", X, "Int", Y, "Ptr", 0, "Ptr", 0)
      ; Update scroll bar.
      NumPut("Int", NewPos, SI, 20) ; nPos
      DllCall("SetScrollInfo", "ptr", H, "Int", Bar, "Ptr", SI, "Int", 1)
   }
}