#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.

; This function will be called when the keyboard shortcut is pressed.
MyFunction() {
    ; Insert code for the function here.
    MsgBox, "Hello, world!"
}
MyFunction := MyFunction()


Gui, Add, Text, x10 y10, Enter a keyboard shortcut:
Gui, Add, Edit, x10 y30 w100 vMyHotkey
Gui, Add, Button, x10 y60, Set Hotkey

Gui, Show

ButtonSetHotkey:
    Hotkey, % MyHotkey, %MyFunction%
    return

