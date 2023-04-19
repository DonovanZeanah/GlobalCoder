#noenv
setbatchlines,-1
settitlematchmode,1

;include the library assumed to be in the parent directory
;remove ../ if in same directory, or specify path
#include ../ShinsImageScanClass.ahk
	;msgbox % "There are " scan.PixelCount(0xFFFFFF) " white pixels on screen!"

scan := new ShinsImageScanClass() ;no title supplied so using desktop instead

1::
^!z::  ; Control+Alt+Z hotkey.
MouseGetPos, MouseX, MouseY
PixelGetColor, color, %MouseX%, %MouseY%
MsgBox The color at the current cursor position is %color%.
clipboard := color 
return
2::
;look for a pure red pixel anywhere on the desktop
InputBox, inp 
send, ^v 
send, {enter}
if (scan.Pixel(inp,10,x,y)) {
	
	msgbox % "Found a red pixel at " x "," y
	MouseMove, x, y 
} else {

	msgbox % "Could not find a red pixel on the desktop!"
}

;count all the white pixels on the desktop screen
return

esc::exitapp
