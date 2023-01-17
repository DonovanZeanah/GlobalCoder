#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

Gui, Add, Button, gRunScript, Run Script
Gui, Add, Button, gTerminateScript, Terminate Script
Gui, Show

global scriptName ;global variable to store the name of the script
return

RunScript:
    scriptName := A_GuiControl
    Run, %scriptName%
    return

TerminateScript:
    Process, Close, %scriptName%
    return

RunScriptGUI(script)
{
    global scriptName
    scriptName := script
    Gui, Show
}