#Persistent
#InstallKeybdHook
#InstallMouseHook

InputHook.Start()
Input, SingleKey, L1, {LControl}{RControl}{LAlt}{RAlt}{LShift}{RShift}{LWin}{RWin}{AppsKey}{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}{Left}{Right}{Up}{Down}{Home}{End}{PgUp}{PgDn}{Del}{Ins}{BS}{CapsLock}{NumLock}{PrintScreen}{Pause}

MsgBox % KeyWaitAny()

; Same again, but don't block the key.
MsgBox % KeyWaitAny("V")

block := {}

dslash := InputHook.EndKey

block.w := 25 
block.h := 25
block.x := 25
block.y := 25

;keys := {}
;keys.start :=InputHook.Start()

SacHook := InputHook("V", "{Esc}")
SacHook.OnChar := Func("SacChar")
SacHook.OnKeyDown := Func("SacKeyDown")
SacHook.OnEnd := Func("SacEnd")
SacHook.KeyOpt("{Backspace}", "N")
SacHook.Start()

MsgBox % KeyWaitCombo()

return

SacChar(ih, char)  ; Called when a character is added to SacHook.Input.
{
    Suffix := ""
    if RegExMatch(ih.Input, "`nm)\w+$", prefix)
        RegExMatch(WordList, "`nmi)^" prefix "\K.*", Suffix)
    
    ToolTip % Suffix, % A_CaretX + 15, % A_CaretY    
    
    ; Intercept Tab only while we're showing a tooltip.
    ih.KeyOpt("{Tab}", Suffix = "" ? "-NS" : "+NS")
}

SacKeyDown(ih, vk, sc)
{
    if (vk = 8) ; Backspace
        SacChar(ih, "")
    else if (vk = 9) ; Tab
        Send % "{Text}" Suffix
        MsgBox, % "1: `n pressed " ih 
}



KeyWaitAny(Options:="")
{
    ih := InputHook(Options)
    if !InStr(Options, "V")
        ih.VisibleNonText := false
    ih.KeyOpt("{All}", "E")  ; End
    ih.Start()
    ErrorLevel := ih.Wait()  ; Store EndReason in ErrorLevel
    return ih.EndKey  ; Return the key name
}

SacEnd()
{
    ExitApp
}

KeyWaitCombo(Options:="")
{
    ih := InputHook(Options)
    if !InStr(Options, "V")
        ih.VisibleNonText := false
    ih.KeyOpt("{All}", "E")  ; End
    ; Exclude the modifiers
    ih.KeyOpt("{LCtrl}{RCtrl}{LAlt}{RAlt}{LShift}{RShift}{LWin}{RWin}", "-E")
    ih.Start()
    ErrorLevel := ih.Wait()  ; Store EndReason in ErrorLevel
    return ih.EndMods . ih.EndKey  ; Return a string like <^<+Esc
}

7::

for k,v in SacHook 
 MsgBox, % "0: `n " SacHook

 ;this is a test of keys 
tooltip

Gui, Add, Button, gCtrlEvent vButton1, Button 1
Gui, Add, Button, gCtrlEvent vButton2, Button 2
Gui, Add, Button, gGoButton, Go Button
Gui, Add, Edit, w300 hvEditField, Example text
Gui, Show,, Functions instead of labels

CtrlEvent(CtrlHwnd:=0, GuiEvent:="", EventInfo:="", ErrLvl:="") {
    GuiControlGet, controlName, Name, %CtrlHwnd%
    MsgBox, %controlName% has been clicked!
}
GoButton(CtrlHwnd:=0, GuiEvent:="", EventInfo:="", ErrLvl:="") {
    GuiControlGet, EditField
    MsgBox, Go has been clicked! The content of the edit field is "%EditField%"!
}

GuiClose(hWnd) {
    WinGetTitle, windowTitle, ahk_id %hWnd%
    MsgBox, The Gui with title "%windowTitle%" has been closed!
    ExitApp
}
return




~[::
Input, UserInput, V T5 L4 C, {enter}.{esc}{tab}``, btw,otoh,fl,ahk,ca
if (ErrorLevel = "Max")
{
    MsgBox, You entered "%UserInput%", which is the maximum length of text.
    return
}
if (ErrorLevel = "Timeout")
{
    MsgBox, You entered "%UserInput%" at which time the input timed out.
    return
}
if (ErrorLevel = "NewInput")
    return
If InStr(ErrorLevel, "EndKey:")
{
    MsgBox, You entered "%UserInput%" and terminated the input with %ErrorLevel%.
    return
}
; Otherwise, a match was found.
if (UserInput = "btw")
    Send, {backspace 4}by the way
else if (UserInput = "otoh")
    Send, {backspace 5}on the other hand
else if (UserInput = "fl")
    Send, {backspace 3}Florida
else if (UserInput = "ca")
    Send, {backspace 3}California
else if (UserInput = "ahk")
    Run, https://www.autohotkey.com
return

global WordList := "Monday`nTuesday`nWednesday`nThursday`nFriday`nSaturday`nSunday"

global Suffix := "", SacHook

3:: 
for k,v in userinput
msgbox, % "4: `n " UserInput


return ;hy the way

