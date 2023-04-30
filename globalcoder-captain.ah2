
#SingleInstance Force
persistent
CoordMode("Mouse", "Screen")
SetTitleMatchMode(2)

;suspend the hotkeys of a running AHK script
DetectHiddenWindows True
full_command_line := DllCall("GetCommandLine", "str")

if not (A_IsAdmin or RegExMatch(full_command_line, " /restart(?!\S)"))
{
    try
    {
        if A_IsCompiled
            Run '*RunAs "' A_ScriptFullPath '" /restart'
        else
            Run '*RunAs "' A_AhkPath '" /restart "' A_ScriptFullPath '"'
    }
    ExitApp
}

MsgBox "A_IsAdmin: " A_IsAdmin "`nCommand line: " full_command_line

TraySetIcon "Shell32.dll", 14


global mwin := "placeholder"

; Use 65306 to Pause and 65303 to Reload instead of Suspend. (see FAQ)
PostMessage 0x0111, 65305,,, A_ScriptName


#h::  ; Win+H hotkey
{
    ; Get the text currently selected. The clipboard is used instead of
    ; EditGetSelectedText because it works in a greater variety of editors
    ; (namely word processors).  Save the current clipboard contents to be
    ; restored later. Although this handles only plain text, it seems better
    ; than nothing:
    ClipboardOld := A_Clipboard
    A_Clipboard := "" ; Must start off blank for detection to work.
    Send "^c"
    if !ClipWait(1)  ; ClipWait timed out.
    {
        A_Clipboard := ClipboardOld ; Restore previous contents of clipboard before returning.
        return
    }
    ; Replace CRLF and/or LF with `n for use in a "send-raw" hotstring:
    ; The same is done for any other characters that might otherwise
    ; be a problem in raw mode:
    ClipContent := StrReplace(A_Clipboard, "``", "````")  ; Do this replacement first to avoid interfering with the others below.
    ClipContent := StrReplace(ClipContent, "`r`n", "``n")
    ClipContent := StrReplace(ClipContent, "`n", "``n")
    ClipContent := StrReplace(ClipContent, "`t", "``t")
    ClipContent := StrReplace(ClipContent, "`;", "```;")
    A_Clipboard := ClipboardOld  ; Restore previous contents of clipboard.
    ShowInputBox(":T:`::" ClipContent)
}

ShowInputBox(DefaultValue)
{
    ; This will move the input box's caret to a more friendly position:
    SetTimer MoveCaret, 10
    ; Show the input box, providing the default hotstring:
    IB := InputBox("
    (
    Type your abreviation at the indicated insertion point. You can also edit the replacement text if you wish.

    Example entry: :T:btw`::by the way
    )", "New Hotstring",, DefaultValue)
    if IB.Result = "Cancel"  ; The user pressed Cancel.
        return

    if RegExMatch(IB.Value, "(?P<Label>:.*?:(?P<Abbreviation>.*?))::(?P<Replacement>.*)", &Entered)
    {
        if !Entered.Abbreviation
            MsgText := "You didn't provide an abbreviation"
        else if !Entered.Replacement
            MsgText := "You didn't provide a replacement"
        else
        {
            Hotstring Entered.Label, Entered.Replacement  ; Enable the hotstring now.
            FileAppend "`n" IB.Value, A_ScriptFullPath  ; Save the hotstring for later use.
        }
    }
    else
        MsgText := "The hotstring appears to be improperly formatted"

    if IsSet(MsgText)
    {
        Result := MsgBox(MsgText ". Would you like to try again?",, 4)
        if Result = "Yes"
            ShowInputBox(DefaultValue)
    }
    
    MoveCaret()
    {
        WinWait "New Hotstring"
        ; Otherwise, move the input box's insertion point to where the user will type the abbreviation.
        Send "{Home}{Right 3}"
        SetTimer , 0
    }
}



HkGui := Gui()
HkGui.Add("Text", "xm", "Prefix key:")
HkGui.Add("Edit", "yp x100 w100 vPrefix", "Space")
HkGui.Add("Text", "xm", "Suffix hotkey:")
HkGui.Add("Edit", "yp x100 w100 vSuffix", "f & j")
HkGui.Add("Button", "Default", "Register").OnEvent("Click", RegisterHotkey)
;HkGui.OnEvent("Close", (*) => ExitApp())
;HkGui.OnEvent("Escape", (*) => ExitApp())
HkGui.Show()



applicationname := "Captain"
;INIREAD()
makeMENU()
TRAYMENU()
global ids := ""

global titles := [] ; Declare the titles array as a global variable

;makes writing color teal in Wordpad
PostMessage 0x0111, 32788, 0, , "Document - WordPad"


ListVars
WinWaitActive "ahk_class AutoHotkey"
WinSetTitle "This is a new title" ; Use the window found by WinWaitActive.
Hotkey "^!z", MyFunc

Return

RegisterHotkey(*)
{

    Saved := HkGui.Submit(false)
    HotIf (*) => GetKeyState(Saved.Prefix)
    Hotkey Saved.Suffix, (ThisHotkey) => MsgBox(ThisHotkey)

    HotIfWinActive "ahk_class Notepad"
    Hotkey "!w", ToggleWordWrap  ; !w = Alt+W

    ToggleWordWrap(ThisHotkey)
    {
        MenuSelect "A",, "Format", "Word Wrap"
    }


}

; Press AppsKey and Alt in any order, then slash (/).
#HotIf GetKeyState("AppsKey", "P")
Alt & /::MsgBox "Hotkey activated."

; If the keys are swapped, Alt must be pressed first (use one at a time):
#HotIf GetKeyState("Alt", "P")
AppsKey & /::MsgBox "Hotkey activated."

; [ & ] & \::
#HotIf GetKeyState("[") && GetKeyState("]")
\::MsgBox
#HotIf





MyFunc(ThisHotkey)
{
    MsgBox "You pressed " ThisHotkey
}

; Press CapsLock and Numpad2 to reload all AutoHotkey scripts
!Numpad2::
ReloadAllAhkScripts(ThisHotkey)
{
    DetectHiddenWindows True
    for hwnd in WinGetList("ahk_class AutoHotkey")
    {
      msgbox hwnd
        if (hwnd A_ScriptHwnd)  ; ignore the current window for reloading
            ;continue
        PostMessage 0x0111, 65303,,, hwnd
    }
    Reload
}




xbutton1::
^mbutton::
^#n::
{ 
captainHOTKEY2()

}

TRAYMENU()
{ 
  TraySetIcon "shell32.dll", 14

  tray := A_TrayMenu ; For convenience.
  tray.delete ; Delete the standard items.

  standardmenu := menu()
  standardmenu.AddStandard()
  standardmenu.add
  standardmenu.Add(applicationname, SETTINGS)
  standardmenu.Add("")
  standardmenu.Add("&Settings...", SETTINGS)
  standardmenu.Add("&About...", ABOUT)
  standardmenu.Add("E&xit", EXIT)
  standardmenu.Default := applicationname
  ;standardmenu.Tip(applicationname)

  tray.Add "Legacy Menu", standardmenu


;Tray:= A_TrayMenu
;Tray.Delete() ; V1toV2: not 100% replacement of NoStandard, Only if NoStandard is used at the beginning
;Return
} ; V1toV2: Added bracket before function
captainHOTKEY2()
{ 
  MouseGetPos(&mx, &my, &mwin, &mctrl)
  ErrorLevel := SendMessage(0x84, , (my<<16)|mx, , "ahk_id " mwin) ;WM_NCHITTEST=0x84
  CHANGE(mwin) ; Pass mwin as a parameter to the CHANGE function
}

/*captainHOTKEY2()
{ 
MouseGetPos(&mx, &my, &mwin, &mctrl)
ErrorLevel := SendMessage(0x84, , (my<<16)|mx, , "ahk_id " mwin) ;WM_NCHITTEST=0x84
;If ErrorLevel=2 ;HTCAPTION
CHANGE()
  ;Menu,menu,Show 

} ; V1toV2: Added bracket before function
*/

makeMENU()
{ 
  menu1 := Menu()
  menu1.Add("C&hange caption", CHANGE2)
  ;menu1.OnCommand("C&hange caption", CHANGE2) ; Assign the CHANGE function to the menu item
  ;menu1.Attach()
}

CHANGE2(*)
{
  if !mwin 
   wmin := "placeholder"
  ; Function body
  title := WinGetTitle("ahk_id " mwin)


  IB := InputBox("New title:", applicationname, , title), newtitle := IB.Value, ErrorLevel := IB.Result="OK" ? 0 : IB.Result="CANCEL" ? 1 : IB.Result="Timeout" ? 2 : "ERROR"

  if (ErrorLevel = 0)
    If (newtitle != title)
    {
      WinSetTitle("ahk_id " mwin, , newtitle)
      ids:=ids . mwin ","
      title_%mwin%:=newtitle
      ;SetTimer(UPDATE,-1000)
}
}


/*makeMENU()
{ ; V1toV2: Added bracket
menu1 := Menu()
menu1.Add("C&hange caption", Func("CHANGE"))

} ; V1toV2: Added Bracket before label
*/

COPY()
{
title := WinGetTitle("ahk_id " mwin)
Clipboard := title
TOOLTIP("Caption copied: " title)
}



CHANGE(mwin)
{ 
  global ids
  title := WinGetTitle("ahk_id " mwin)
    MsgBox "Current title: " title

    IB := InputBox("New title:", applicationname, , title), newtitle := IB.Value, ErrorLevel := IB.Result="OK" ? 0 : IB.Result="CANCEL" ? 1 : IB.Result="Timeout" ? 2 : "ERROR"
    /*
      B := InputBox("New title:", applicationname, , title), 
      newtitle := IB.Value, 
      ErrorLevel := IB.Result="OK" ? 0 : IB.Result="CANCEL" ? 1 : IB.Result="Timeout" ? 2 : "ERROR"
    */
    MsgBox "New title: " newtitle
    MsgBox "ErrorLevel: " ErrorLevel

    if (ErrorLevel = 0)
    {
      If (newtitle != title)
      {
        WinSetTitle(newtitle, title) ; Updated function call
        ids := ids . mwin ","
        titles.push(newtitle)
        MsgBox "Title changed to: " newtitle
        MsgBox "Updated ids: " ids

        ; Display the contents of the titles array using a loop
              titlesList := ""
              for index, title in titles
              {
                titlesList := titlesList . "Title " . index . ": " . title . "`n"
              }
              MsgBox "Titles array: `n" titlesList

        ;SetTimer(UPDATE, -1000)
      }
    }
  }
  ;This should resolve the issue with the WinSetTitle() function call, and the code should now work as expected.









/*UPDATE()
{ ; V1toV2: Added bracket
  global ids 
Loop Parse, ids, ","
{
  if !WinExist("ahk_id " A_LoopField)
  {
    ; StrReplace() is not case sensitive
    ; check for StringCaseSense in v1 source script
    ; and change the CaseSense param in StrReplace() if necessary
    ids := StrReplace(ids, A_LoopField ",",,,, 1)
    ;title_ . A_LoopField =
    ;Continue
  }
  ctitle := WinGetTitle("ahk_id " A_LoopField)
  msgbox ctitle
  If (ctitle!=A_LoopField)
    WinSetTitle("ahk_id " A_LoopField, , A_LoopField)
}
SetTimer(UPDATE,-1000)
Return
} ; V1toV2: Added bracket before function
*/

TOOLTIP(tip)
{
  ToolTip(tip)
  SetTimer(Func("TOOLTIPOFF"),-3000)
}


TOOLTIPOFF()
{ ; V1toV2: Added bracket
  ;ToolTip "You left-clicked in Gui window '" thisGui.Title "' at client coordinates " X "x" Y "." Control
  ;ToolTip("You left-clicked in Gui window '" thisGui.Title "' at client coordinates " X "x" Y "." Control")

ToolTip("off")
Return
} ; V1toV2: Added bracket before function

; Rest of the code remains the same


SETTINGS(*) ;(A_ThisMenuItem, A_ThisMenuItemPos, MyMenu)
{ ; V1toV2: Added bracket
Hotkey(hotkey, HOTKEY, "Off")

myGui := Gui()
myGui.OnEvent("Close", GuiEscape)
myGui.OnEvent("Escape", GuiEscape)
myGui.Destroy()

ini := Fileread(applicationname ".ini")
myGui.SetFont("Courier New")
myGui.Add("Edit", "Vnewini -Wrap W400", ini)
myGui.SetFont()

ogcButtonOK := myGui.Add("Button", "GSETTINGSOK Default W75", "&OK")
ogcButtonOK.OnEvent("Click", ButtonOK.Bind("Normal"))
ogcButtonCancel := myGui.Add("Button", "GSETTINGSCANCEL x+5 W75", "&Cancel")
ogcButtonCancel.OnEvent("Click", ButtonCancel.Bind("Normal"))
myGui.Show(applicationname . " Settings")

} ; V1toV2: Added Bracket before label


/*SETTINGSOK:
oSaved := myGui.Submit()
;FileDelete(applicationname ".ini")
;FileAppend(newini, applicationname ".ini")
;INIREAD()
Return*/


GuiEscape(*)
{ ; V1toV2: Added bracket
GuiClose:
SETTINGSCANCEL:
myGui.Destroy()
Hotkey(hotkey, HOTKEY, "On")
Return
} ; V1toV2: Added bracket before function


EXIT(*) ;A_ThisMenuItem, A_ThisMenuItemPos, MyMenu)
{ ; V1toV2: Added bracket
ExitApp()
} ; V1toV2: Added bracket before function


ABOUT(*) ;(A_ThisMenuItem, A_ThisMenuItemPos, MyMenu)
{ ; V1toV2: Added bracket
oGui99 := Gui()
oGui99.OnEvent("Close", _99GuiClose)
oGui99.Destroy()
oGui99.MarginX := "20", oGui99.MarginY := "20"
oGui99.Add("Picture", "xm Icon1", applicationname . ".exe")
oGui99.SetFont("Bold")
oGui99.Add("Text", "x+10 yp+10", applicationname . " v1.2")
oGui99.SetFont()
oGui99.Add("Text", "y+10", "Copy and change a window's title")
oGui99.Add("Text", "y+5", "- Use the middle mousebutton on a window's caption")
oGui99.Add("Text", "y+5", "- Change hotkey using Settings in the tray menu")

oGui99.Add("Picture", "xm y+20 Icon5", applicationname . ".exe")
oGui99.SetFont("Bold")
oGui99.Add("Text", "x+10 yp+10", "1 Hour Software by Skrommel")
oGui99.SetFont()
oGui99.Add("Text", "y+10", "For more tools, information and donations, please visit")
oGui99.SetFont("CBlue Underline")
oGui99.Add("Text", "y+5 G1HOURSOFTWARE", "www.1HourSoftware.com")
oGui99.SetFont()

oGui99.Add("Picture", "xm y+20 Icon7", applicationname . ".exe")
oGui99.SetFont("Bold")
oGui99.Add("Text", "x+10 yp+10", "DonationCoder")
oGui99.SetFont()
oGui99.Add("Text", "y+10", "Please support the contributors at")
oGui99.SetFont("CBlue Underline")
oGui99.Add("Text", "y+5 GDONATIONCODER", "www.DonationCoder.com")
oGui99.SetFont()

oGui99.Add("Picture", "xm y+20 Icon6", applicationname . ".exe")
oGui99.SetFont("Bold")
oGui99.Add("Text", "x+10 yp+10", "AutoHotkey")
oGui99.SetFont()
oGui99.Add("Text", "y+10", "This tool was made using the powerful")
oGui99.SetFont("CBlue Underline")
oGui99.Add("Text", "y+5 GAUTOHOTKEY", "www.AutoHotkey.com")
oGui99.SetFont()

oGui99.Opt("+AlwaysOnTop")
oGui99.Title := applicationname . " About"
oGui99.Show()
hCurs:=DllCall("LoadCursor", "UInt", NULL, "Int", 32649, "UInt") ;IDC_HAND
OnMessage(0x200, WM_MOUSEMOVE) 
Return
} ; V1toV2: Added Bracket before label



_99GuiClose(*)
{ ; V1toV2: Added bracket
  oGui99.Destroy()
  OnMessage(0x200, WM_LBUTTONDOWN)
  DllCall("DestroyCursor", "Uint", hCur)
Return
} ; V1toV2: Added bracket before function

WM_MOUSEMOVE(wParam,lParam)
{
  Global hCurs
  MouseGetPos(, , , &ctrl)
  if (ctrl ~= "^(?i:Static9|Static13|Static17)$")
    DllCall("SetCursor", "UInt", hCurs)
  
}

/* older gpt
#SingleInstance Force
CoordMode("Mouse", "Screen")
SetTitleMatchMode(2)

applicationname := "Captain"
;INIREAD()
makeMENU()
TRAYMENU()
ids := ""
Return

xbutton1::
^mbutton::
^#n::
{ 
captainHOTKEY2()

}

captainHOTKEY2()
{ 
MouseGetPos(&mx, &my, &mwin, &mctrl)
ErrorLevel := SendMessage(0x84, , (my<<16)|mx, , "ahk_id " mwin) ;WM_NCHITTEST=0x84
;If ErrorLevel=2 ;HTCAPTION
CHANGE()
  ;Menu,menu,Show 

} ; V1toV2: Added bracket before function


makeMENU()
;Menu,menu,Add,&Copy caption,COPY
{ ; V1toV2: Added bracket
menu1 := Menu()
menu1.Add("C&hange caption", CHANGE)

} ; V1toV2: Added Bracket before label


COPY(){
title := WinGetTitle("ahk_id " mwin)
Clipboard := title
TOOLTIP("Caption copied: " title)
}



CHANGE()
{ ; V1toV2: Added bracket
title := WinGetTitle("ahk_id " mwin)
IB := InputBox("New title:", applicationname, , title), newtitle := IB.Value, ErrorLevel := IB.Result="OK" ? 0 : IB.Result="CANCEL" ? 1 : IB.Result="Timeout" ? 2 : "ERROR"
if (ErrorLevel = 0)
  If (newtitle != title)
  {
    WinSetTitle(newtitle, "ahk_id " mwin)
    ids:=ids . mwin ","
    title_%mwin%:=newtitle
    SetTimer(UPDATE,-1000)
  }  

Return
} ; V1toV2: Added Bracket before label

UPDATE()
{ ; V1toV2: Added bracket
Loop Parse, ids, ","
{
  if !WinExist("ahk_id " A_LoopField)
  {
    ; StrReplace() is not case sensitive
    ; check for StringCaseSense in v1 source script
    ; and change the CaseSense param in StrReplace() if necessary
    ids := StrReplace(ids, A_LoopField ",",,,, 1)
    ;title_ . A_LoopField =
    ;Continue
  }
  ctitle := WinGetTitle("ahk_id " A_LoopField)
  If (ctitle!=title_%A_LoopField%)
    WinSetTitle(title_%A_LoopField%, "ahk_id " A_LoopField)
}
SetTimer(UPDATE,-1000)
Return
} ; V1toV2: Added bracket before function


TOOLTIP(tip)
{
  ToolTip(tip)
  SetTimer(TOOLTIPOFF,-3000)
}


TOOLTIPOFF()
{ ; V1toV2: Added bracket
  ;ToolTip "You left-clicked in Gui window '" thisGui.Title "' at client coordinates " X "x" Y "." Control
  ;ToolTip("You left-clicked in Gui window '" thisGui.Title "' at client coordinates " X "x" Y "." Control")

ToolTip("off")
Return
} ; V1toV2: Added bracket before function


TRAYMENU()
{ ; V1toV2: Added bracket
Tray:= A_TrayMenu
Tray.Delete() ; V1toV2: not 100% replacement of NoStandard, Only if NoStandard is used at the beginning
Tray.Add(applicationname, SETTINGS)
Tray.Add("")
Tray.Add("&Settings...", SETTINGS)
Tray.Add("&About...", ABOUT)
Tray.Add("E&xit", EXIT)
Tray.Default := applicationname
Tray.Tip(applicationname)
Return
} ; V1toV2: Added bracket before function


/*INIREAD()
{ ; V1toV2: Added bracket
if !FileExist(applicationname ".ini")
{
  ini := "
(
`;[Settings]
`;hotkey=^LButton    `;!=Alt +=Shift ^=Ctrl #=Win 

[Settings]
hotkey=^LButton 
)"
  FileAppend(ini, applicationname ".ini")
}
hotkey := IniRead(applicationname ".ini", "Settings", "hotkey")
If (hotkey="" Or hotkey="ERROR")
  Hotkey(":= `"^LButton`"")
Hotkey(hotkey, captainHOTKEY2, "On")
Return
} ; V1toV2: Added Bracket before label


SETTINGS(A_ThisMenuItem, A_ThisMenuItemPos, MyMenu)
{ ; V1toV2: Added bracket
Hotkey(hotkey, HOTKEY, "Off")
myGui := Gui()
myGui.OnEvent("Close", GuiEscape)
myGui.OnEvent("Escape", GuiEscape)
myGui.Destroy()
ini := Fileread(applicationname ".ini")
myGui.SetFont("Courier New")
myGui.Add("Edit", "Vnewini -Wrap W400", ini)
myGui.SetFont()
ogcButtonOK := myGui.Add("Button", "GSETTINGSOK Default W75", "&OK")
ogcButtonOK.OnEvent("Click", ButtonOK.Bind("Normal"))
ogcButtonCancel := myGui.Add("Button", "GSETTINGSCANCEL x+5 W75", "&Cancel")
ogcButtonCancel.OnEvent("Click", ButtonCancel.Bind("Normal"))
myGui.Show(applicationname . " Settings")
Return
} ; V1toV2: Added Bracket before label


SETTINGSOK:
oSaved := myGui.Submit()
;FileDelete(applicationname ".ini")
;FileAppend(newini, applicationname ".ini")
;INIREAD()
Return


GuiEscape(*)
{ ; V1toV2: Added bracket
GuiClose:
SETTINGSCANCEL:
myGui.Destroy()
Hotkey(hotkey, HOTKEY, "On")
Return
} ; V1toV2: Added bracket before function


EXIT(A_ThisMenuItem, A_ThisMenuItemPos, MyMenu)
{ ; V1toV2: Added bracket
ExitApp()
} ; V1toV2: Added bracket before function


ABOUT(A_ThisMenuItem, A_ThisMenuItemPos, MyMenu)
{ ; V1toV2: Added bracket
oGui99 := Gui()
oGui99.OnEvent("Close", _99GuiClose)
oGui99.Destroy()
oGui99.MarginX := "20", oGui99.MarginY := "20"
oGui99.Add("Picture", "xm Icon1", applicationname . ".exe")
oGui99.SetFont("Bold")
oGui99.Add("Text", "x+10 yp+10", applicationname . " v1.2")
oGui99.SetFont()
oGui99.Add("Text", "y+10", "Copy and change a window's title")
oGui99.Add("Text", "y+5", "- Use the middle mousebutton on a window's caption")
oGui99.Add("Text", "y+5", "- Change hotkey using Settings in the tray menu")

oGui99.Add("Picture", "xm y+20 Icon5", applicationname . ".exe")
oGui99.SetFont("Bold")
oGui99.Add("Text", "x+10 yp+10", "1 Hour Software by Skrommel")
oGui99.SetFont()
oGui99.Add("Text", "y+10", "For more tools, information and donations, please visit")
oGui99.SetFont("CBlue Underline")
oGui99.Add("Text", "y+5 G1HOURSOFTWARE", "www.1HourSoftware.com")
oGui99.SetFont()

oGui99.Add("Picture", "xm y+20 Icon7", applicationname . ".exe")
oGui99.SetFont("Bold")
oGui99.Add("Text", "x+10 yp+10", "DonationCoder")
oGui99.SetFont()
oGui99.Add("Text", "y+10", "Please support the contributors at")
oGui99.SetFont("CBlue Underline")
oGui99.Add("Text", "y+5 GDONATIONCODER", "www.DonationCoder.com")
oGui99.SetFont()

oGui99.Add("Picture", "xm y+20 Icon6", applicationname . ".exe")
oGui99.SetFont("Bold")
oGui99.Add("Text", "x+10 yp+10", "AutoHotkey")
oGui99.SetFont()
oGui99.Add("Text", "y+10", "This tool was made using the powerful")
oGui99.SetFont("CBlue Underline")
oGui99.Add("Text", "y+5 GAUTOHOTKEY", "www.AutoHotkey.com")
oGui99.SetFont()

oGui99.Opt("+AlwaysOnTop")
oGui99.Title := applicationname . " About"
oGui99.Show()
hCurs:=DllCall("LoadCursor", "UInt", NULL, "Int", 32649, "UInt") ;IDC_HAND
OnMessage(0x200, WM_MOUSEMOVE) 
Return
} ; V1toV2: Added Bracket before label



_99GuiClose(*)
{ ; V1toV2: Added bracket
  oGui99.Destroy()
  OnMessage(0x200, WM_LBUTTONDOWN)
  DllCall("DestroyCursor", "Uint", hCur)
Return
} ; V1toV2: Added bracket before function

WM_MOUSEMOVE(wParam,lParam)
{
  Global hCurs
  MouseGetPos(, , , &ctrl)
  if (ctrl ~= "^(?i:Static9|Static13|Static17)$")
    DllCall("SetCursor", "UInt", hCurs)
  Return
}*/