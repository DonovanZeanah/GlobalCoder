InsertAHKItems.Activate()
Return

; Insert AHK Commands/Functions with Parameters with Auto-Complete
; original by boiler, class mod by toralf
; https://www.autohotkey.com/boards/viewtopic.php?f=60&t=31484
;
; Usage:
;	- CapsLock: Start command/function entry, searching from start of command/function name
;	- Shift + CapsLock: alternate between the two search algorithms (entry must match from start or entry can be anywhere in command/function name)
;	- Enter or Tab to select command/function/method/directive/keyword (can use up/down arrows to navigate command/function list)
;	- Parameter list will be displayed -- multiple versions if there are alternatives
;	- Enter or Tab to select parameter list (can use up/down arrows to navigate alternate parameter lists)
;	- Escape to return to normal editing
;
; It should work with any editor that allows pasting and returns caret positions (Sublime Text does not).
; Some may require special treatment as was done for SciTE4AHK (activates the edit control in case the Find box is open).

class InsertAHKItems
{
    Activate() {
      SetTitleMatchMode, 1
      GroupAdd, Editors, ahk_exe notepad.exe
      GroupAdd, Editors, ahk_exe notepad++.exe
      GroupAdd, Editors, ahk_exe ahk_exe SciTE.exe
      GroupAdd, Editors, AutoGUI ahk_class AutoHotkeyGUI
      GroupAdd, Editors, AHK Studio ahk_class AutoHotkeyGUI

      CoordMode, Caret, Screen

      this.ReadAHKItems()
      this.CreateSelectionGui()
      this.CreateParameterGui()
      this.SetHotkeys()
      this.Instance := this
    }
    
    ReadAHKItems() {
      FuncNeedle = OS)^([_#.\w\d]*)\s*:=
      CommandNeedle = OS)^([_#.\w\d]*)(.*)
      ExpressionNeedle = :=
    
      FilePattern := A_LineFile "\..\AHKItems\*.csv"
      this.AllItems := {}
      Loop, Files, %FilePattern%
      {
        FileName := A_LoopFileName
        Loop, Read, %A_LoopFileLongPath%
        {
          Line := Trim(A_LoopReadLine)
          
          If !Line
            Continue
          If (InStr(Line, ";") = 1)
            Continue
          
          ReturnValue =
          If (RegExMatch(Line, FuncNeedle, Match))
          {
            ReturnValue := Match.1
            Line := Trim(SubStr(Line, InStr(Line,ExpressionNeedle) + StrLen(ExpressionNeedle)))
          }
          
          If !RegExMatch(Line, CommandNeedle, Match)
            MsgBox, Problem in File %FileName% on Line %A_Index% with %Line%
          
          Command := "|" Match.1  ;precede with a "|" to avoid setting a predefined method or property
          Parameter := Match.2
          If isObject(this.AllItems[Command])
            this.AllItems[Command].push( {Para: Parameter, Return: ReturnValue, File: FileName} )
          Else
            this.AllItems[Command]  := [ {Para: Parameter, Return: ReturnValue, File: FileName} ]
        }
      }
    }

    CreateSelectionGui() {
      Gui, New, +hwndhGui -Caption +AlwaysOnTop +ToolWindow
      this.SelectionHwnd := hGui
      Gui, Font, s10, Consolas
      Gui, Margin, 0, 0
      Gui, Add, Edit, w170 h20 hwndhEdit gInsertAHKItems.On_CommandTypingEvent
      this.CommandSearchHwnd := hEdit
      Gui, Add, ListBox, h0 w170 hwndhLsb -HScroll
      this.CommandChoiceHwnd := hLsb
      Gui, Show, Hide AutoSize, InsertAHKItemsSelectionGui
    }
    
    CreateParameterGui() {
      Gui, New, +hwndhGui -Caption +AlwaysOnTop +ToolWindow +Delimiter~ ; because pipe appears in parameter lists
      this.ParameterHwnd := hGui
      Gui, Font, s10, Consolas
      Gui, Margin, 0, 0
      Gui, Add, ListBox, h0 w300 hwndhLsb -HScroll
      this.ParamDisplayHwnd := hLsb
      Gui, Show, Hide AutoSize, InsertAHKItemsParameterGui
    }

    SetHotkeys() {
      Hotkey, IfWinActive, ahk_group Editors
      functor := ObjBindMethod(this, "ShowSelectionGui")      
      Hotkey, CapsLock, % functor

      Hotkey, IfWinActive, InsertAHKItemsSelectionGui ahk_exe AutoHotkey.exe
      functor := ObjBindMethod(this, "ChangeSelectionAlgo")      
      Hotkey, +CapsLock, % functor
      functor := ObjBindMethod(this, "HideGui")      
      Hotkey, ESC, % functor
      functor := ObjBindMethod(this, "MoveSelectionUp", this.CommandChoiceHwnd, this.SelectionHwnd)      
      Hotkey, Up, % functor
      functor := ObjBindMethod(this, "MoveSelectionDown", this.CommandChoiceHwnd, this.SelectionHwnd)      
      Hotkey, Down, % functor
      functor := ObjBindMethod(this, "EnterSelection", this.CommandChoiceHwnd, False)      
      Hotkey, Enter, % functor
      Hotkey, Tab, % functor
      
      Hotkey, IfWinActive, InsertAHKItemsParameterGui ahk_exe AutoHotkey.exe
      functor := ObjBindMethod(this, "HideGui")      
      Hotkey, ESC, % functor
      functor := ObjBindMethod(this, "MoveSelectionUp", this.ParamDisplayHwnd, this.ParameterHwnd)      
      Hotkey, Up, % functor
      functor := ObjBindMethod(this, "MoveSelectionDown", this.ParamDisplayHwnd, this.ParameterHwnd)      
      Hotkey, Down, % functor
      functor := ObjBindMethod(this, "EnterSelection", this.ParamDisplayHwnd, True)      
      Hotkey, Enter, % functor
      Hotkey, Tab, % functor

      Hotkey, If
    }
    
    ShowSelectionGui() {
      GuiControl,, % this.CommandSearchHwnd    ; clear entry
      GuiControl,, % this.CommandChoiceHwnd, | ; clear list
      GuiControl, Hide, % this.CommandChoiceHwnd
      Gui, % this.SelectionHwnd ":Show", x%A_CaretX% y%A_CaretY% AutoSize
    }
    
    ChangeSelectionAlgo() {
      this.Anywhere := !this.Anywhere
      this.On_CommandTypingEvent()
    }

    HideGui() {
      Gui, % this.SelectionHwnd ":Hide"
      Gui, % this.ParameterHwnd ":Hide"
    }

    MoveSelectionUp(CtrlHwnd, GuiHwnd) {
      GuiControl, Choose, %CtrlHwnd%, % this.HighlightedCommand > 1 ? this.HighlightedCommand -= 1 : this.HighlightedCommand := this.ListCount
      Gui, %GuiHwnd%:Show, AutoSize		
    }

    MoveSelectionDown(CtrlHwnd, GuiHwnd) {
      GuiControl, Choose, %CtrlHwnd%, % this.HighlightedCommand < this.ListCount ? this.HighlightedCommand += 1 : this.HighlightedCommand := 1
      Gui, %GuiHwnd%:Show, AutoSize		
    }


    On_CommandTypingEvent() {
      this := InsertAHKItems.Instance
      GuiControlGet, CommandEntry,, % this.CommandSearchHwnd
      If CommandEntry
      {
        ListCount := 0
        For Command, Data in this.AllItems
        {
          If (this.Anywhere AND InStr(Command, CommandEntry)) ; matches anywhere
          {
            PipedCommandList .= Command 
            ListCount++
          }
          Else If (!this.Anywhere AND (InStr(Command, CommandEntry) = 2)) ; matches at start, first char is pipe
          {
            PipedCommandList .= Command 
            ListCount++
          }
        }
      }
     	GuiControl, Move, % this.CommandChoiceHwnd, % "h" 4 + 15 * (ListCount > 4 ? 5 : ListCount)
      GuiControl, % ListCount ? "Show" : "Hide", % this.CommandChoiceHwnd
      GuiControl,, % this.CommandChoiceHwnd, %PipedCommandList%
      GuiControl, Choose, % this.CommandChoiceHwnd, % this.HighlightedCommand := 1
      Gui, % this.SelectionHwnd ":Show", AutoSize
      this.ListCount := ListCount
    }
    
    EnterSelection(CtrlHwnd, OnlyPaste) {
      GuiControlGet, SelectedItem,, % this.ListCount ? CtrlHwnd : this.CommandSearchHwnd
      this.HideGui()
      If !SelectedItem
        Return 
      WinWaitActive, ahk_group Editors
      CurrentCaretX := A_CaretX
      this.Paste(SelectedItem)
      If (OnlyPaste or !this.ListCount)
        Return

      MaxChars := 0   
      For i, Data in this.AllItems[ "|" SelectedItem]
      {
        PipedParamList .= "~" Data.Para 
        MaxChars := Max(StrLen(Data.Para), MaxChars)
        this.ListCount := i
      }
      If !MaxChars  ;no parameter found
        Return

      GuiControl, , % this.ParamDisplayHwnd, %PipedParamList%
      GuiControl, Move, % this.ParamDisplayHwnd, % "w" (8 + MaxChars * 7) " h" (4 + 15 * this.ListCount)
      GuiControl, Choose, % this.ParamDisplayHwnd, % this.HighlightedParam := 1

      While (A_CaretX = CurrentCaretX)
        Sleep, 50   ; wait until paste is complete so gui is in correct place
      Gui, % this.ParameterHwnd ":Show", x%A_CaretX% y%A_CaretY% AutoSize
    }
    
    Paste(text) {
      IfWinActive, ahk_exe ahk_exe SciTE.exe
        ControlFocus, Scintilla1, A ; so that find/replace pane doesn't get focus
      savedClip := ClipboardAll
      Clipboard := text
      Send ^v
      Clipboard := savedClip
    }
}
