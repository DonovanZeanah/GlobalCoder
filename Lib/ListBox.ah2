;These functions and labels are related to the shown list of words

InitializeListBox()
{
   global
   
   ListBoxGui := Gui()
   ListBoxGui.Opt("-DPIScale -Caption +AlwaysOnTop +ToolWindow +Delimiter" . g_DelimiterChar)
   
   Local ListBoxFont
   if (prefs_ListBoxFontOverride && prefs_ListBoxFontOverride != "<Default>")
   {
      ListBoxFont := prefs_ListBoxFontOverride
   } else    if (prefs_ListBoxFontFixed = "On")
   {
      ListBoxFont := "Courier New"
   } else {
      ListBoxFont := "Tahoma"
   }
      
   ListBoxGui.SetFont("s" . prefs_ListBoxFontSize, ListBoxFont)

   Loop prefs_ListBoxRows
   {
      ogcg_ListBox%A_Index%.Options("-Redraw")
      ;can't use a g-label here as windows sometimes passes the click message when spamming the scrollbar arrows
      ListBoxGui.Add("ListBox", "vg_ListBox" . A_Index . " R" . A_Index . " X0 Y0 T" . prefs_ListBoxFontSize . " T32" . A_Index)
      g_ListBoxHwnd := ogcg_ListBox.hwnd
   }

   Return
}
   
ListBoxClickItem(wParam, lParam, msg, ClickedHwnd)
{
   global
   Local NewClickedItem
   Local TempRows
   static LastClickedItem
   
   TempRows := GetRows()
   
   if (ClickedHwnd != g_ListBoxHwnd%TempRows%)
   {
      return
   }
   
   ; if we clicked in the scrollbar, jump out
   if (A_GuiX > (g_ListBoxPosX + g_ListBoxContentWidth))
   {
      SetSwitchOffListBoxTimer()
      Return
   }
   
   g_MatchPos := ogcg_ListBox%TempRows%.Text
   
   if (msg == g_WM_LBUTTONUP)
   {
      if !(prefs_DisabledAutoCompleteKeys ~= "i)(L)")
      {
         SwitchOffListBoxIfActive()
         EvaluateUpDown("$LButton")   
      } else {
         ; Track this to make sure we're double clicking on the same item
         NewClickedItem := g_MatchPos
         SetSwitchOffListBoxTimer()
      }
         
   } else if (msg == g_WM_LBUTTONDBLCLK)
   {
      SwitchOffListBoxIfActive()
      
      if (prefs_DisabledAutoCompleteKeys ~= "i)(L)")
      {
         if (LastClickedItem == g_MatchPos)
         {
            EvaluateUpDown("$LButton")   
         }
      }
   } else {
      SwitchOffListBoxIfActive()
   }
      
   ; clear or set LastClickedItem
   LastClickedItem := NewClickedItem
   
   Return
}

SetSwitchOffListBoxTimer()
{
   static DoubleClickTime
   
   if !(DoubleClickTime)
   {
      DoubleClickTime := DllCall("GetDoubleClickTime")
   }
   ;When single click is off, we have to wait for the double click time to pass
   ; before re-activating the edit window to allow double click to work
   SetTimer(SwitchOffListBoxIfActiveSub,-%DoubleClickTime%)
}
   

SwitchOffListBoxIfActiveSub()
{ ; V1toV2: Added bracket
SwitchOffListBoxIfActive()
Return
} ; V1toV2: Added bracket before function

ListBoxScroll(Hook, Event, EventHwnd)
{
   global
   
   Local MatchEnd
   Local SI
   Local TempRows
   Local Position
   
   if (g_ListBox_Id)
   {
   
      TempRows := GetRows()
      if (g_ListBoxHwnd%TempRows% != EventHwnd)
      {
         return
      }
      
      if (Event == g_EVENT_SYSTEM_SCROLLINGSTART)
      {
         ; make sure the timer is clear so we don't switch while scrolling
         SetTimer(SwitchOffListBoxIfActiveSub,0)
         return
      }
      
      SI:=GetScrollInfo(g_ListBoxHwnd%TempRows%)
   
      if (!SI.npos)
      {
         return
      }
   
      if (SI.npos == g_MatchStart)
      {
         return
      }
   
      g_MatchStart := SI.npos
   
      SetSwitchOffListBoxTimer()   
   }
}

; based on code by HotKeyIt
;  http://www.autohotkey.com/board/topic/78829-ahk-l-scrollinfo/
;  http://www.autohotkey.com/board/topic/55150-class-structfunc-sizeof-updated-010412-ahkv2/
GetScrollInfo(ctrlhwnd) {
  global g_SB_VERT
  global g_SIF_POS
  SI:=new _Struct("cbSize,fMask,nMin,nMax,nPage,nPos,nTrackPos")
  SI.cbSize:=sizeof(SI)
  SI.fMask := g_SIF_POS
  If !DllCall("GetScrollInfo", "PTR", ctrlhwnd, "Int", g_SB_VERT, "PTR", SI[""])
    Return false
  else Return SI
}

ListBoxChooseItem(Row)
{
   global
   ogcg_ListBox%Row%.Choose(%g_MatchPos%)
}

;------------------------------------------------------------------------

CloseListBox()
{
   global g_ListBox_Id
   if (g_ListBox_Id != "")
   {
      ListBoxGui.Hide()
      ListBoxEnd()
   }
   Return
}

DestroyListBox()
{
   ListBoxGui.Destroy()
   ListBoxEnd()
   Return
}

ListBoxEnd()
{
   global g_ScrollEventHook
   global g_ScrollEventHookThread
   global g_ListBox_Id
   global g_WM_LBUTTONUP
   global g_WM_LBUTTONDBLCLK
   
   g_ListBox_Id := ""
   
   OnMessage(g_WM_LBUTTONUP)
   OnMessage(g_WM_LBUTTONDBLCLK)

   if (g_ScrollEventHook) {
      DllCall("UnhookWinEvent", "Uint", g_ScrollEventHook)
      g_ScrollEventHook := ""
      g_ScrollEventHookThread := ""
      MaybeCoUninitialize()
   }
   DisableKeyboardHotKeys()
   return
}

;------------------------------------------------------------------------

SavePriorMatchPosition()
{
   global g_MatchPos
   global g_MatchStart
   global g_OldMatch
   global g_OldMatchStart
   global g_SingleMatch
   global prefs_ArrowKeyMethod
   
   if !(g_MatchPos)
   {
      g_OldMatch := ""
      g_OldMatchStart := ""
   } else    if (prefs_ArrowKeyMethod = "LastWord")
   {
      g_OldMatch := g_SingleMatch[g_MatchPos]
      g_OldMatchStart := ""
   } else    if (prefs_ArrowKeyMethod = "LastPosition")
   {
      g_OldMatch := g_MatchPos
      g_OldMatchStart := g_MatchStart
   } else {
      g_OldMatch := ""
      g_OldMatchStart := ""
   }
      
   Return
}

SetupMatchPosition()
{
   global g_MatchPos
   global g_MatchStart
   global g_MatchTotal
   global g_OldMatch
   global g_OldMatchStart
   global g_SingleMatch
   global prefs_ArrowKeyMethod
   global prefs_ListBoxRows
   
   if (g_OldMatch = "")
   {
      if (prefs_ArrowKeyMethod = "Off")
      {
         g_MatchPos := ""
         g_MatchStart := "1"
      } else {
         g_MatchPos := "1"
         g_MatchStart := "1"
      }
   } else    if (prefs_ArrowKeyMethod = "Off")
   {
      g_MatchPos := ""
      g_MatchStart := "1"
   } else    if (prefs_ArrowKeyMethod = "LastPosition")
   {
      if (StrCompare(g_OldMatch, g_MatchTotal) > 0)
      {
         g_MatchStart := g_MatchTotal - (prefs_ListBoxRows - 1)
         if (g_MatchStart < 1)
            g_MatchStart := "1"
         g_MatchPos := g_MatchTotal
      } else {
         g_MatchStart := g_OldMatchStart
         If ( g_MatchStart > (g_MatchTotal - (prefs_ListBoxRows - 1) ))
         {
            g_MatchStart := g_MatchTotal - (prefs_ListBoxRows - 1)
            if (g_MatchStart < 1)
               g_MatchStart := "1"
         }
         g_MatchPos := g_OldMatch
      }
   
   } else    if (prefs_ArrowKeyMethod = "LastWord")
   {
      ListPosition := ""
      Loop g_MatchTotal
      {
         if ( g_OldMatch == g_SingleMatch[A_Index] )
         {
            ListPosition := A_Index
            Break
         }
      }
      if (ListPosition = "")
      {
         g_MatchPos := "1"
         g_MatchStart := "1"
      } Else {
         g_MatchStart := ListPosition - (prefs_ListBoxRows - 1)
         if (g_MatchStart < 1)
            g_MatchStart := "1"
         g_MatchPos := ListPosition
      }
   } else {
      g_MatchPos := "1"
      g_MatchStart := "1"
   }
             
   g_OldMatch := ""
   g_OldMatchStart := ""
   Return
}

RebuildMatchList()
{
   global g_Match
   global g_MatchLongestLength
   global g_MatchPos
   global g_MatchStart
   global g_MatchTotal
   global g_OriginalMatchStart
   global prefs_ListBoxRows
   
   g_Match := ""
   g_MatchLongestLength := ""
   
   if (!g_MatchPos)
   {
      ; do nothing
   } else if (g_MatchPos < g_MatchStart)
   {
      g_MatchStart := g_MatchPos
   } else if (g_MatchPos > (g_MatchStart + (prefs_ListBoxRows - 1)))
   {
      g_MatchStart := g_MatchPos - (prefs_ListBoxRows -1)
   }
   
   g_OriginalMatchStart := g_MatchStart
   
   MaxLength := ComputeListBoxMaxLength()
   HalfLength := Round(MaxLength/2)
   
   Loop g_MatchTotal
   {
      CurrentLength := AddToMatchList(A_Index, MaxLength, HalfLength, 0, true)
      if (StrCompare(CurrentLength, LongestBaseLength) > 0)
         LongestBaseLength := CurrentLength      
   }
   
   Loop g_MatchTotal
   {
      CurrentLength := AddToMatchList(A_Index, MaxLength, HalfLength, LongestBaseLength, false)
      if (StrCompare(CurrentLength, g_MatchLongestLength) > 0)
         g_MatchLongestLength := CurrentLength      
   }
   g_Match := SubStr(g_Match, 1, -1*(1))        ; Get rid of the last linefeed 
   Return
}

AddToMatchList(position, MaxLength, HalfLength, LongestBaseLength, ComputeBaseLengthOnly)
{
   global g_DelimiterChar
   global g_Match
   global g_MatchStart
   global g_NumKeyMethod
   global g_SingleMatch
   global g_SingleMatchDescription
   global g_SingleMatchReplacement
   global prefs_ListBoxFontFixed
   
   blankprefix := "`t"
   
   if (g_NumKeyMethod = "Off")
   {
      prefix := blankprefix
   } else    if (StrCompare(position, g_MatchStart) < 0)
   {
      prefix := blankprefix
   } else if ( position > ( g_MatchStart + 9 ) )
   {
      prefix := blankprefix
   } else {
      prefix := Mod(position - g_MatchStart +1,10) . "`t"
   }
   
   prefixlen := 2
   
   CurrentMatch := g_SingleMatch[position]
   if (g_SingleMatchReplacement[position] || g_SingleMatchDescription[position])
   {
      AdditionalDataExists := true
      BaseLength := HalfLength
   } else if (ComputeBaseLengthOnly) {
      ; we don't need to compute the base length if there
      ; is no Replacement or Description
      Return 0
   } else {
      BaseLength := MaxLength
   }
   
   CurrentMatchLength := StrLen(CurrentMatch) + prefixlen
   
   if (CurrentMatchLength > BaseLength)
   {
      CompensatedBaseLength := BaseLength - prefixlen
      ; remove 3 characters so we can add the ellipsis
      CurrentMatch := SubStr(CurrentMatch, 1, CompensatedBaseLength - 3)
      CurrentMatch .= "..."
   
      CurrentMatchLength := StrLen(CurrentMatch) + prefixlen
   }
   
   if (ComputeBaseLengthOnly)
   {
      Return CurrentMatchLength
   }
   
   Iterations := 0
   Tabs := ""
   Remainder := 0
   
   if (AdditionalDataExists) 
   {
      if (g_SingleMatchReplacement[position])
      {
         CurrentMatch .= " " . chr(26) . " " . g_SingleMatchReplacement[position]
      }
      if (g_SingleMatchDescription[position])
      {
         ;;CurrentMatch .= "|" . g_SingleMatchDescription[position]
         if (prefs_ListBoxFontFixed = "On")
         {
            Iterations := Ceil(LongestBaseLength/8) - Floor((strlen(CurrentMatch) + prefixlen)/8)
         
            Remainder := Mod(strlen(CurrentMatch) + prefixlen, 8)
         
            Loop Iterations
            {
               Tabs .= Chr(9)
            }
         } else {
            Iterations := 1
            Remainder := 0
            Tabs := Chr(9)
         }
         
         CurrentMatch .= Tabs . "|" . g_SingleMatchDescription[position]
      }
         
      CurrentMatchLength := strlen(CurrentMatch) + prefixlen - strlen(Tabs) + (Iterations * 8) - Remainder
      
      ;MaxLength - prefix length to make room for prefix
      if (CurrentMatchLength > MaxLength)
      {
         CompensatedMaxLength := MaxLength - prefixlen + strlen(Tabs) - (Iterations * 8) + Remainder
         ; remove 3 characters so we can add the ellipsis
         CurrentMatch := SubStr(CurrentMatch, 1, CompensatedMaxLength - 3)
         CurrentMatch .= "..."
         CurrentMatchLength := strlen(CurrentMatch) + prefixlen - strlen(Tabs) + (Iterations * 8) - Remainder
      }
   }
   
   g_Match .= prefix . CurrentMatch
   
   g_Match .= g_DelimiterChar
   Return CurrentMatchLength
}

;------------------------------------------------------------------------

; find out the longest length we can use in the listbox
; Any changes to this function probably need to be reflected in ShowListBox() or ForceWithinMonitorBounds
ComputeListBoxMaxLength()
{
   global g_ListBoxCharacterWidthComputed
   global g_MatchTotal
   global g_SM_CMONITORS
   global g_SM_CXFOCUSBORDER
   global g_SM_CXVSCROLL
   global prefs_ListBoxMaxWidth
   
   ; grab the width of a vertical scrollbar

   Rows := GetRows()
   
   if (StrCompare(g_MatchTotal, Rows) > 0)
   {
      ScrollBarWidth := SysGet(g_SM_CXVSCROLL)
      if !isInteger(ScrollBarWidth)
         ScrollBarWidth := "17"
   } else ScrollBarWidth := "0"

   ; Grab the internal border width of the ListBox box
   BorderWidthX := SysGet(g_SM_CXFOCUSBORDER)
   if !isInteger(BorderWidthX)
      BorderWidthX := "1"
   
   ;Use 8 pixels for each character in width
   ListBoxBaseSizeX := g_ListBoxCharacterWidthComputed + ScrollBarWidth + (BorderWidthX * 2)
   
   ListBoxPosX := HCaretX()
   ListBoxPosY := HCaretY()
   
   NumMonitors := SysGet(g_SM_CMONITORS)

   if (NumMonitors < 1)
      NumMonitors := "1"
         
   Loop NumMonitors
   {
      MonitorGet(A_Index, &MonLeft, &MonTop, &MonRight, &MonBottom)
      IF ( ( ListBoxPosX < MonLeft ) || (ListBoxPosX > MonRight ) || ( ListBoxPosY < MonTop ) || (ListBoxPosY > MonBottom ) )
         Continue
      
      MonWidth := MonRight - MonLeft
      break
   }
   
   if !prefs_ListBoxMaxWidth
   {
      Width := MonWidth
   } else if (prefs_ListBoxMaxWidth < MonWidth)
   {
      Width := prefs_ListBoxMaxWidth
   } else 
   {
      Width := MonWidth
   }
   
   return Floor((Width-ListBoxBaseSizeX)/ g_ListBoxCharacterWidthComputed)
}
   

;Show matched values
; Any changes to this function may need to be reflected in ComputeListBoxMaxLength()
ShowListBox()
{
   global

   if (g_Match != "")
   {
      Local BorderWidthX
      Local ListBoxActualSize
      Local ListBoxActualSizeH
      Local ListBoxActualSizeW
      Local ListBoxPosY
      Local ListBoxSizeX
      Local ListBoxThread
      Local MatchEnd
      Local Rows
      Local ScrollBarWidth
      static ListBox_Old_Cursor

      Rows := GetRows()
      
      if (StrCompare(g_MatchTotal, Rows) > 0)
      {
         ScrollBarWidth := SysGet(g_SM_CXVSCROLL)
         if !isInteger(ScrollBarWidth)
            ScrollBarWidth := "17"
      } else ScrollBarWidth := "0"
   
      ; Grab the internal border width of the ListBox box
      BorderWidthX := SysGet(g_SM_CXFOCUSBORDER)
      if !isInteger(BorderWidthX)
         BorderWidthX := "1"
      
      ;Use 8 pixels for each character in width
      ListBoxSizeX := g_ListBoxCharacterWidthComputed * g_MatchLongestLength + g_ListBoxCharacterWidthComputed + ScrollBarWidth + (BorderWidthX * 2)
      
      g_ListBoxPosX := HCaretX()
      ListBoxPosY := HCaretY()
      
      ; In rare scenarios, the Cursor may not have been detected. In these cases, we just won't show the ListBox.
      IF (!(g_ListBoxPosX) || !(ListBoxPosY))
      {
         return
      }
      
      MatchEnd := g_MatchStart + (prefs_ListBoxRows - 1)
      
      Loop prefs_ListBoxRows
      { 
         if (A_Index = Rows)
         {
            ogcg_ListBox%A_Index%.Options("-Redraw")
            ogcg_ListBox%A_Index%.Move(, , ListBoxSizeX)
            ogcg_ListBox%A_Index%.Value := g_DelimiterChar "" g_Match
            if (g_MatchPos != "")
            {
               ogcg_ListBox%A_Index%.Choose(%MatchEnd%)
               ogcg_ListBox%A_Index%.Choose(%g_MatchPos%)
            }
            ogcg_ListBox%A_Index%.Options("+AltSubmit +Redraw")
            ogcg_ListBox%A_Index%.Visible := true
            ogcg_ListBox%A_Index%.GetPos(&ListBoxActualSizeX, &ListBoxActualSizeY, &ListBoxActualSizeW, &ListBoxActualSizeH)
            Continue
         }
      
         ogcg_ListBox%A_Index%.Visible := false
         ogcg_ListBox%A_Index%.Options("-Redraw")
         ogcg_ListBox%A_Index%.Value := g_DelimiterChar
      }
      
      ForceWithinMonitorBounds(g_ListBoxPosX,ListBoxPosY,ListBoxActualSizeW,ListBoxActualSizeH)
      
      g_ListBoxContentWidth := ListBoxActualSizeW - ScrollBarWidth - BorderWidthX
      
      if (g_ListBox_Id = "")
      {
         
         if !(prefs_DisabledAutoCompleteKeys ~= "i)(L)")
         {
            if (!ListBox_Old_Cursor)
            {
               ListBox_Old_Cursor := DllCall(g_SetClassLongFunction, "Uint", g_ListBoxHwnd%Rows%, "int", g_GCLP_HCURSOR, "int", g_cursor_hand)
            }
            
            DllCall(g_SetClassLongFunction, "Uint", g_ListBoxHwnd%Rows%, "int", g_GCLP_HCURSOR, "int", g_cursor_hand)
            
         ; we only need to set it back to the default cursor if we've ever unset the default cursor
         } else if (ListBox_Old_Cursor)
         {
            DllCall(g_SetClassLongFunction, "Uint", g_ListBoxHwnd%Rows%, "int", g_GCLP_HCURSOR, "int", ListBox_Old_Cursor)
         }
            
      }
      
      ListBoxGui.Show("NoActivate X" . g_ListBoxPosX . " Y" . ListBoxPosY . " H" . ListBoxActualSizeH . " W" . ListBoxActualSizeW, "Word List Appears Here.")
      ListBoxGui.Opt("+LastFound +AlwaysOnTop")
      
      if (g_ListBox_Id = "")
      {
         
         EnableKeyboardHotKeys()   
      }
      
      g_ListBox_Id := WinGetID("Word List Appears Here.")
      
      ListBoxThread := DllCall("GetWindowThreadProcessId", "Ptr", g_ListBox_Id, "Ptr", g_NULL)
      if (g_ScrollEventHook && (ListBoxThread != g_ScrollEventHookThread))
      {
         DllCall("UnhookWinEvent", "Uint", g_ScrollEventHook)
         g_ScrollEventHook := ""
         g_ScrollEventHookThread := ""
         MaybeCoUninitialize()
      }
         
      if (!g_ScrollEventHook) {
         MaybeCoInitializeEx()
         g_ScrollEventHook := DllCall("SetWinEventHook", "Uint", g_EVENT_SYSTEM_SCROLLINGSTART, "Uint", g_EVENT_SYSTEM_SCROLLINGEND, "Ptr", g_NULL, "Uint", g_ListBoxScrollCallback, "Uint", g_PID, "Uint", ListBoxThread, "Uint", g_NULL)
         g_ScrollEventHookThread := ListBoxThread
      }
      
      OnMessage(g_WM_LBUTTONUP, ListBoxClickItem)
      OnMessage(g_WM_LBUTTONDBLCLK, ListBoxClickItem)
      
      if (prefs_ListBoxOpacity != 255)
         WinSetTransparent(prefs_ListBoxOpacity, "ahk_id " g_ListBox_Id)
   }
}

; Any changes to this function may need to be reflected in ComputeListBoxMaxLength()
ForceWithinMonitorBounds(&ListBoxPosX,&ListBoxPosY,ListBoxActualSizeW,ListBoxActualSizeH)
{
   global g_ListBoxFlipped
   global g_SM_CMONITORS
   global g_ListBoxCharacterWidthComputed
   global g_ListBoxOffsetComputed
   global g_ListBoxMaxWordHeight
   ;Grab the number of non-dummy monitors
   NumMonitors := SysGet(g_SM_CMONITORS)
   
   if (NumMonitors < 1)
      NumMonitors := "1"
         
   Loop NumMonitors
   {
      MonitorGet(A_Index, &MonLeft, &MonTop, &MonRight, &MonBottom)
      IF ( ( ListBoxPosX < MonLeft ) || (ListBoxPosX > MonRight ) || ( ListBoxPosY < MonTop ) || (ListBoxPosY > MonBottom ) )
         Continue
      
      if (ListBoxActualSizeH > g_ListBoxMaxWordHeight) {
         g_ListBoxMaxWordHeight := ListBoxActualSizeH
      }
      
      ; + g_ListBoxOffsetComputed Move ListBox down a little so as not to hide the caret. 
      ListBoxPosY := ListBoxPosY + g_ListBoxOffsetComputed
      if (g_ListBoxFlipped) {
         ListBoxMaxPosY := HCaretY() - g_ListBoxMaxWordHeight
         
         if (ListBoxMaxPosY < MonTop) {
            g_ListBoxFlipped := ""
         } else {
            ListBoxPosY := HCaretY() - ListBoxActualSizeH
         }
      }
      
      ; make sure we don't go below the screen.
      If ( (ListBoxPosY + g_ListBoxMaxWordHeight ) > MonBottom )
      {
         ListBoxPosY := HCaretY() - ListBoxActualSizeH
         g_ListBoxFlipped := true
      }
      
      ; make sure we don't go above the top of the screen.
      If (ListBoxPosY < MonTop) {
         ListBoxPosY := MonTop
         ; Try to move over horizontal position to leave some space, may get overridden later.
         ListBoxPosX += g_ListBoxCharacterWidthComputed
      }
      
      If ( (ListBoxPosX + ListBoxActualSizeW ) > MonRight )
      {
         ListBoxPosX := MonRight - ListBoxActualSizeW
         If ( ListBoxPosX < MonLeft )
            ListBoxPosX := MonLeft
      }
         
         
      Break
   }

   Return 
}

;------------------------------------------------------------------------

GetRows()
{
   global g_MatchTotal
   global prefs_ListBoxRows
   if (StrCompare(g_MatchTotal, prefs_ListBoxRows) > 0)
      Rows := prefs_ListBoxRows
   else Rows := g_MatchTotal
   
   Return Rows
}
;------------------------------------------------------------------------

; function to grab the X position of the caret for the ListBox
HCaretX() 
{
   global g_DpiAware
   global g_DpiScalingFactor
   global g_Helper_Id
   global g_Process_DPI_Unaware
    
   WinGetPos(&HelperX, , , , "ahk_id " g_Helper_Id)
   if (HelperX != "")
   { 
      return HelperX
   } 
   if ( CheckIfCaretNotDetectable() )
   { 
      MouseGetPos(&MouseX)
      return MouseX
   }
   ; non-DPI Aware
   if (g_DpiAware == g_Process_DPI_Unaware) {
      return (A_CaretX * g_DpiScalingFactor)
   }
   
   return A_CaretX 
} 

;------------------------------------------------------------------------

; function to grab the Y position of the caret for the ListBox
HCaretY() 
{
   global g_DpiAware
   global g_DpiScalingFactor
   global g_Helper_Id
   global g_Process_DPI_Unaware

   WinGetPos(, &HelperY, , , "ahk_id " g_Helper_Id)
   if (HelperY != "")
   { 
      return HelperY
   } 
   if ( CheckIfCaretNotDetectable() )
   { 
      MouseGetPos(, &MouseY)
      return MouseY + (20*g_DpiScalingFactor)
   }
   if (g_DpiAware == g_Process_DPI_Unaware) {
      return (A_CaretY * g_DpiScalingFactor)
   }
   
   return A_CaretY 
}

;------------------------------------------------------------------------

CheckIfCaretNotDetectable()
{
   ;Grab the number of non-dummy monitors
   NumMonitors := SysGet(80)
   
   if (NumMonitors < 1)
      NumMonitors := "1"
   
   if !(A_CaretX)
   {
      Return 1
   }
   
   ;if the X caret position is equal to the leftmost border of the monitor +1, we can't detect the caret position.
   Loop NumMonitors
   {
      MonitorGet(A_Index, &MonLeft, &MonTop, &MonRight, &MonBottom)
      if ( A_CaretX = ( MonLeft ) )
      {
         Return 1
      }
      
   }
   
   Return 0
}
