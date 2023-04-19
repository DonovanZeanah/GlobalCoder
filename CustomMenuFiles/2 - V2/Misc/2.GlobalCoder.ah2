

Editor := FileSelect(2,, "Select your editor", "Programs (*.exe)")
if Editor = ""
    ExitApp
RegWrite "REG_SZ", "egedit
",, Format('"{1}" "%1"', Editor)
/*
The InputHook function returns an InputHook object, which has the following methods and properties.

Methods:
KeyOpt: Sets options for a key or list of keys.
Start: Starts collecting input.
Stop: Terminates the Input and sets EndReason to the word Stopped.
Wait: Waits until the Input is terminated (InProgress is false).

General Properties:
EndKey: Returns the name of the end key which was pressed to terminate the Input.
EndMods: Returns a string of the modifiers which were logically down when Input was terminated.
EndReason: Returns an EndReason string indicating how Input was terminated.
InProgress: Returns true if the Input is in progress and false otherwise.
Input: Returns any text collected since the last time Input was started.
Match: Returns the MatchList item which caused the Input to terminate.
OnEnd: Retrieves or sets the function object which is called when Input is terminated.
OnChar: Retrieves or sets the function object which is called after a character is added to the input buffer.
OnKeyDown: Retrieves or sets the function object which is called when a notification-enabled key is pressed.
OnKeyUp: Retrieves or sets the function object which is called when a notification-enabled key is released.

Option Properties:
BackspaceIsUndo: Controls whether Backspace removfsses the most recently pressed character from the end of the Input buffer.
CaseSensitive: Controls whether MatchList is case sensitive.
FindAnywhere: Controls whether each match can be a substring of the input text.
MinSendLevel: Retrieves or sets the minimum send level of input to collect.
NotifyNonText: Controls whether the OnKeyDown and OnKeyUp callbacks are called whenever a non-text key is pressed.
Timeout: Retrieves or sets the timeout value in seconds.
VisibleNonText: Controls whether keys or key combinations which do not produce text are visible (not blocked).
VisibleText: Controls whether keys or key combinations which produce text are visible (not blocked).
*/

WordList := "Monday`nTuesday`nWednesday`nThursday`nFriday`nSaturday`nSunday"

Suffix := ""

SacHook := InputHook("V", "{Esc}")
SacHook.OnChar := SacChar
SacHook.OnKeyDown := SacKeyDown
SacHook.KeyOpt("{Backspace}", "N")
SacHook.Start()

SacChar(ih, char)  ; Called when a character is added to SacHook.Input.
{
    global Suffix := ""
    if RegExMatch(ih.Input, "`nm)\w+$", &prefix)
        && RegExMatch(WordList, "`nmi)^" prefix[0] "\K.*", &Suffix)
        Suffix := Suffix[0]
    
    if CaretGetPos(&cx, &cy)
        ToolTip Suffix, cx + 15, cy
    else
        ToolTip Suffix

    ; Intercept Tab only while we're showing a tooltip.
    ih.KeyOpt("{Tab}", Suffix = "" ? "-NS" : "+NS")
}

SacKeyDown(ih, vk, sc)
{
    if (vk = 8) ; Backspace
        SacChar(ih, "")
    else if (vk = 9) ; Tab
        Send "{Text}" Suffix
}
