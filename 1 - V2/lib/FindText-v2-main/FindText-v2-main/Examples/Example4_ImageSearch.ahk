#include ..\FindText.ahk
WinActivate("Examples.png")
WinWaitActive("Examples.png")

if FindText().ImageSearch(&X,&Y,,,,, A_ScriptDir "\Examples.png") ; Looks for the image in Examples.png on the screen
    MouseMove(X, Y) ; ImageSearch coordinates use A_CoordModePixel which is "Client" by default, so MouseTip() will display in the wrong place 

if FindText().ImageSearch(&X,&Y,,,,, "|<auto>*159$40.0000k000003000000A00DVUnw7lr6371nUAMAA630FUkkkAT63330rgMAAA1kFUkkkD363330wAAAA62vkvkkQtt1v1kS8") ; Looks for the "auto" image contained in the Text
    MouseMove(X, Y) ; ImageSearch coordinates use A_CoordModePixel which is "Client" by default, so MouseTip() will display in the wrong place 