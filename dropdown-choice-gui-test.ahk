Gui, Add, DropDownList, AltSubmit vdropChoice gLaunch, 6-WayFixed||6-way size|4-way fixed

; Makes a close button.
Gui, Add, Button, gGuiClose, Close
Gui, Add, Button, gGuiSubmit, Submit


; Shows the gui
Gui, Show, AutoSize, DDL Example
return

; Label to run with gui gosub.
launch:
Gui, Submit, NoHide
Hotkey, 2, %dropchoice%
return

GuiSubmit:
Gui, Submit, NoHide
Hotkey, 2, %dropchoice%
return

1:
run notepad.exe
return

2:
run chrome.exe
return

3:
run word.exe
return

GuiClose:
ExitApp