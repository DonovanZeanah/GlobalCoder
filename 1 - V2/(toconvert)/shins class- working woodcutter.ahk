#singleinstance,force
setbatchlines,-1
settitlematchmode,2

;#include <ShinsImageScanClass>
;#include <ShinsOverlayClass>

class test{

	__New(n){
		this.n := n 
	}
}



color := []
;treeColors := [0xFF4D6A,0x15433A,0x173834,0x375A12,0x355610,0x457016, 0x35400B] ;create an array of colors, to add more just seperate them by commas
treeColors := [0xFF4D6A, 0x181819] ;create an array of colors, to add more just seperate them by commas
treeColors1 := [] ;create an array of colors, to add more just seperate them by commas



scan := new ShinsImageScanClass("OBS 27.2.4 (64-bit, windows) - Profile: Untitled - Scenes: Untitled")
overlay := new ShinsOverlayClass("OBS 27.2.4 (64-bit, windows) - Profile: Untitled - Scenes: Untitled") ;initally create a static overlay
settimer,draw,10 ;overlay essentially requires a timer if attaching to window, as the window checks are done in the BeginDraw() function
return

;scan := new ShinsImageScanClass("RuneLite")
;overlay := new ShinsOverlayClass("RuneLite") ;initally create a static overlay


esc::exitapp

draw:
mousegetpos,mx,my
;if (mx > 0 and my > 0 and mx < scan.width and my < scan.height)
scan := new ShinsImageScanClass("OBS 27.2.4 (64-bit, windows) - Profile: Untitled - Scenes: Untitled")
color := scan.GetPixel(mx,my) & 0xFFFFFF

if (overlay.BeginDraw()) { 
    overlay.DrawText("tohex() value under mouse: " tohex(color),100,100,48)
    overlay.DrawText("original color from method under mouse: tt this form: " color,50,50,48)
    overlay.EndDraw() ;must always be called to end the drawing and update the overlay
}

;color := scan.GetPixel(mx,my) & 0xFFFFFF
for k,v in treeColors
{
	
	;tooltip % treecolors
	color := v
	hcolor := tohex(v)
	tooltip % "color from array: " color "__my array color to hexcolor: " hcolor
	sleep 1000
    if (scan.Pixel(color,10,x,y)) {
    	scan.click(x,y)
    	;msgbox % clicked that with method
        mousemove,  x , y 
        mouseclick,left, x , y

        break ;if you found the pixel then break the loop
    }
    tooltip, broke , x , y
  
}
return



xbutton2 & z::  ; Control+Alt+Z hotkey.
MouseGetPos, MouseX, MouseY
PixelGetColor, color, %MouseX%, %MouseY%
MsgBox The color at the current cursor position is %color%.
clipboard := color
scan := new ShinsImageScanClass("OBS 27.2.4 (64-bit, windows) - Profile: Untitled - Scenes: Untitled") 
color := scan.GetPixel(MouseX,MouseY) & 0xFFFFFF
msgbox % color
msgbox % tohex(color)
return 

^2::

settimer, videoloop, 100

videoloop:
for k,v in treeColors
{
    if (scan.Pixel(v,1,x,y)) {
        mousemove,  x , y 
        mousemove, x , y

        break ;if you found the pixel then break the loop
    }
}
  tooltip, broke , x , y
return


/*if (scan.Pixel(clist,1,x,y)) {
	mousemove,  x , y 
	}
	tooltip, broke , x , y
return
*/



;scan := new ShinsImageScanClass("RuneLite") 
/*clist = 
(
	  rrr
0x15433A
0x173834
0x0D322E
)

*/


/*
;scan := new ShinsImageScanClass("VLC media player")
;E47DFF - pink

0xfFfeof
0xffcceb
0xffb3d9
0xFF99CC
0xff8ObF
0xfF69b4
0xff66b3
0xff4da6
0xFF3399
0xff1a8c
0xFFO080
0xe60073
0xccQ066
*/




;scan.SaveImage("ab" . i++ . ".png")
;file := "ab" . i++ . ".png"
;if (scan.Pixel(0xFFC0CB,2,x,y)) {

	;msgbox % "Found a pink pixel at " x "," y
	 
	;run, %file%,,, file1

;	msgbox % "Could not find a red pixel on the desktop!"




^3::

DllCall("QueryPerformanceCounter", "Int64*", CounterBefore)
DllCall("QueryPerformanceCounter", "Int64*", CounterAfter)
DllCall("QueryPerformanceFrequency", "Int64*", Frequency)
MsgBox % "Elapsed QPC time is " . (CounterAfter - CounterBefore)*1000/Frequency . " milliseconds"
Loop, Parse, clist , `n , `r
If (A_LoopField !="")
	{
		; msgbox % a_loopfield ;works
	;look for a pink pixel in chosen window

	if (scan.Pixel(a_loopfield,,x,y)) {
	tooltip % "Found a pink pixel at " x "," y
	mousemove,  x , y  
;	msgbox % "Could not find a red pixel on the desktop!"
	}
}
else  
{
	msgbox fuck 
	return
}
DllCall("QueryPerformanceCounter", "Int64*", CounterAfter)
DllCall("QueryPerformanceFrequency", "Int64*", Frequency)
MsgBox % "Elapsed QPC time is " . (CounterAfter - CounterBefore)*1000/Frequency . " milliseconds"
;count all the white pixels on the desktop screen


return
;exitapp


/*DllCall("QueryPerformanceCounter", "Int64*", CounterBefore)
Sleep 1000
DllCall("QueryPerformanceCounter", "Int64*", CounterAfter)
DllCall("QueryPerformanceFrequency", "Int64*", Frequency)
MsgBox % "Elapsed QPC time is " . (CounterAfter - CounterBefore)*1000/Frequency . " milliseconds"
*/

/*list =
(
dog
cat
fish
bird
)

list2 =
(
9
1
8
2
7
3
)

list3 = (dog, cat, fish, bird)

msgbox % list

Loop, Parse, list, `n, `r
{
	If (A_LoopField !="")
	{
	msgbox, %A_LoopField%
;	send %A_LoopField%
;	send {Enter}
	}
}

msgbox % list2

Loop, Parse, list2, `n, `r
{
	If (A_LoopField !="")
	{
	msgbox, %A_LoopField%
;	send %A_LoopField%
;	send {Enter}
	}
}

msgbox % list3

Loop, Parse, list3, `,, `( `)  
{
	If (A_LoopField !="")
	{
	msgbox, %A_LoopField%
;	send %A_LoopField%
;	send {Enter}
	}
}
=
*/

toHex(n,prefix=0) {
    neg := false
    if (n < 0) {
        neg := true
        n := abs(n)
    }
    s := ""
    if (n = 0)
        return (prefix ? "0x" : "") "00"
    while (n >= 1) {
        rem := floor(mod(n,16))
        s := chr(rem + (rem > 9 ? 55 : 48)) s
        n := n/16
    }
    return (neg ? "-" : "") (prefix ? "0x" : "") (strlen(s) = 1 ? "0" : "") s
}