


global WordList := "Monday`nTuesday`nWednesday`nThursday`nFriday`nSaturday`nSunday"

global Suffix := "", SacHook

SacHook := InputHook("V", "{Esc}")
SacHook.OnChar := Func("SacChar")
SacHook.OnKeyDown := Func("SacKeyDown")
SacHook.OnEnd := Func("SacEnd")
SacHook.KeyOpt("{Backspace}", "N")
SacHook.Start()

~;::
Input, UserInput, V T5 L4 C, {enter}.{esc}{tab}, btw,otoh,fl,ahk,ca
switch ErrorLevel
{
case "Max":
    MsgBox, You entered "%UserInput%", which is the maximum length of text.
    return
case "Timeout":
    MsgBox, You entered "%UserInput%" at which time the input timed out.
    return
case "NewInput":
    return
default:
    if InStr(ErrorLevel, "EndKey:")
    {
        MsgBox, You entered "%UserInput%" and terminated the input with %ErrorLevel%.
        return
    }
}
switch UserInput
{
case "btw":   Send, {backspace 4}by the way
case "otoh":  Send, {backspace 5}on the other hand
case "fl":    Send, {backspace 3}Florida
case "ca":    Send, {backspace 3}California
case "ahk":   Send, {backspace 4}
Run, https://www.autohotkey.com
}
return
;

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
}

SacEnd()
{
    ExitApp
}