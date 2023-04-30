#singleinstance,force
setbatchlines,-1
settitlematchmode,2
CoordMode, mouse, window 
CoordMode, pixel, window
CoordMode, tooltip, window

#include <``ShinsImageScanClass>
#include <ShinsOverlayClass>

/*scan := new ShinsImageScanClass("Untitled - Paint")
scan.UseControlClirck := 1 
overlay := new ShinsOverlayClass("Untitled - Paint")
*/ ;initally create a static overlay
;overlay essentially requires a timer if attaching to window, as the window checks are done in the BeginDraw() function
;1579033 = 181819
;treeColors := [0xFF4D6A,0x15433A,0x173834,0x375A12,0x355610,0x457016, 0x35400B] ;create an array of colors, to add more just seperate them by commas
;scan := new ShinsImageScanClass("RuneLite")
;overlay := new ShinsOverlayClass("RuneLite") ;initally create a static overlay
;if (mx > 0 and my > 0 and mx < scan.width and my < scan.height)
;scan := new ShinsImageScanClass("OBS 27.2.4 (64-bit, windows) - Profile: Untitled - Scenes: Untitled")
;color := scan.GetPixel(mx,my) & 0xFFFFFF
;16731498 is 

MouseGetPos, outputx, OutputY
cursorcolor := scan.getpixel(outputx, OutputY)
cursorcolor.seControlClick := 1

msgbox % cursorcolor	

global i := 1
global d := {}
d := MouseGetPos()
color := {}
;treecolors := [0x6FA3FF,0xF578FF,0xFF4D6A, 0x181819,0xFF4D6A,0x15433A,0x173834,0x375A12,0x355610,0x457016, 0x35400B] ;create an array of colors, to add more just seperate them by commas

return



/*    
` & 1::
scan := new ShinsImageScanClass("OBS")
scan.UseControlClick := 1 
overlay := new ShinsOverlayClass("OBS")
settimer,draw1,10 
msgbox % scan.Image("p:\app\app\shins\pink.png", 5, x,y)
return

draw1:
for k,v in treecolors
{
	color := v
if (scan.Pixel(tohex(color),,x,y)) {
    	msgbox % color "`n was found" 
    	scan.click(x,y)

			if (overlay.BeginDraw()) { 
    		overlay.DrawText("tohex() value under mouse: " tohex(color),100,100,48)
    		overlay.DrawText("original color from method under mouse: tt this form: " color,50,50,48)
    		overlay.EndDraw() ;must always be called to end the drawing and update the overlay
}
}
}
return
*/


~` & 1::
scan := new Shinsimagescanclass("RuneLite")
scan.UseControlClick := 1 
settimer, timer1, 500
;scan.pixelregion()
return

timer1:

scan.UseControlClick := 1 

if (scan.Pixel(0x454D20,,x,y)) {
	
	tooltip % "Found a pixel at " x "," y
	mousemove,  x , y  
	MouseClick, r, X, Y, 1, 
	sleep, 500
	if (scan.Pixel(0x00FFFF,,bx,by)) {
		
		;mousemove,  bx , by 
		;sleep, 500
		;mousemove,  bx+5 , by+8
		;sleep, 3000
	MouseClick, , bx+5 , by+8, 1, 
	tooltip, yes
	sleep, 5000
}
	}
	return

` & 2::
settimer, timer2, 500
;scan.pixelregion()
return

timer2:
scan := new Shinsimagescanclass("RuneLite")
scan.UseControlClick := 1 
;msgbox % scan.imagecount("logs.png")
tooltip, % scan.imagearray("logs.png",a)
loop % a.length() {
tooltip % a_index ": " a[a_index].x "," a[a_index].y
MouseClick, r, a[a_index].x , a[a_index].y
sleep, 100
if (scan.imagearray("drop.png", a)){


	mouseclick, l, a[a_index].x , a[a_index].y
}




}

if (!scan.Image("logs.png")){
msgbox % " no logs "
send, {enter}
settimer, timer2, off 
settimer, timer1, 1000
Gosub, timer1
}
return 




` & 3::
scan := new Shinsimagescanclass("RuneLite")
scan.UseControlClick := 1 
if (scan.image("swords.png",0,swordx,swordy)){
	swordw := 202
	swordh := 294
	settimer, timer3, 500
	}
return
	timer3:
	scan.ImageCountRegion("logs.png", swordx, swordy,swordw,swordh).click()
tooltip % scan.ImageCountRegion("logs.png", swordx, swordy,swordw,swordh)



` & 4::return
` & 5::return
` & 6::return
` & 7::return
` & 8::return
` & 9::return




` & 0::
global loopnum := 1
treecolors := [0x77FF55,0x6FA3FF,0xF578FF,0xFF4D6A, 0x181819,0xFF4D6A,0x15433A,0x173834,0x375A12,0x355610,0x457016, 0x35400B] ;create an array of colors, to add more just seperate them by commas
settimer,draw0, 10
return

draw0:
scan := new ShinsImageScanClass("OBS")
/*MouseGetPos(Options := 3) {
color := scan.GetPixel(mx,my) & 0xFFFFFF
MouseGetPos, X, Y, Win, Ctrl, % Options
MouseGetPos, MX, MY
PixelGetColor, color, %MX%, %MY%

Return {X: X, Y: Y, Win: Win, Ctrl: Ctrl, color : color }
	}
*/

for k,v in treeColors
{

msgbox % "looping treecolors: `n"  v
ToolTip, % "looping on this value :" v . "loop # " loopnum++, 5, 25, 1

msgbox % "value to tohex: `n " tohex(v,1)
ToolTip, % tohex(v,1) " tohex(v,1)", 5, 50, 2

d := MouseGetPos()
msgbox % "returned from d.color: `n" . d.color
tooltip, % d.color " d.color using color := scan.GetPixel(mx,my) & 0xFFFFFF " , 5, 75, 3

PixelGetColor, nativeformat	, d.x , d.y 
msgbox % "ahk getpixel: `n" . nativeformat
tooltip, % nativeformat " pixelgetcolor native, using d.x, d.y coords" , 5, 100, 4

hcolor := scan.GetPixel(d.x , d.y)
msgbox % "scan.getpixel: `n" . hcolor
tooltip, % hcolor " hcolor: using scan.getpixel(d.x, d.y)", 5, 125, 5

hcolor2 := scan.GetPixel(d.x , d.y)
msgbox % "tohex(hcolor, 1) : `n" . hcolor2
tooltip, % hcolor2 " hcolor2: using tohex(scan.getpixel(d.x, d.y),1)" , 5, 150, 6



msgbox % "please god let one value match  " ;. getfrompaint 

inputbox, getfrompaint, getfrompaint
tooltip, %  getfrompaint "from paint: ", 5, 150, 7

msgbox % "add the actual value from paint to 1 index of array, click ok, and try again"
msgbox % "im testing on #77FF55 which is neon green ( from paint)"

msgbox % "should match on 2nd loop"

	if (scan.Pixel(tohex(v,1),5,x,y)) {
    msgbox % v "v: was found"
    scan.click(x,y)

	tooltip % "2: color from array: " color "     3: my array color to hexcolor: " hcolor
		msgbox % hcolor "-- the first color in the defined array, passed into tohex() about to be inputted"
break
}
else 
{
    if (scan.Pixel(d.color, 5,x,y)) {
    	msgbox % d.color " d.color: was found"
    	scan.click(x,y)

			if (overlay.BeginDraw()) { 
    		overlay.DrawText("tohex() value under mouse: " tohex(color),100,100,48)
    		overlay.DrawText("original color from method under mouse: tt this form: " color,50,50,48)
    		overlay.EndDraw() ;must always be called to end the drawing and update the overlay
}
break
}

else if (scan.Pixel(hcolor,5,x,y)) {
    	msgbox % hcolor "hcolor: was found"
    	loop, 10
    	{
    	MouseMove, d,x, d.Y , 
    	MouseMove, X, Y 
    }
    	if (overlay.BeginDraw()) { 
    		overlay.DrawText("tohex() value under mouse: " tohex(color),100,100,48)
    		overlay.DrawText("original color from method under mouse: tt this form: " color,50,50,48)
    		overlay.EndDraw() ;must always be called to end the drawing and update the overlay
    	}

    	msgbox "end" 
    	break
    }


}

}
msgbox % "went through full cycle of k,v loop"
return

;0xFF5BE4 is standadrd color for what paint says is F5578FF
;reload
;#77FF55

;msgbox % " hcolor  " hcolor " and >: " nativeformat " and v: " v
;msgbox % " tohex(hcolor): " tohex(hcolor) "`n tohex(hcolor2): " tohex(hcolor2) " and >: " nativeformat " and v: " v

	;tooltip % "1:" k ":" v "___iteration:" i++ , mx-30, my-30, 2
	;color := v````
	;msgbox % v "hexvalue input is 'color' to scan with shin class "
	;msgbox % color "-input is 'hcolor' to scan with shin class tohex(v)-" hcolor

xbutton2 & z::  ; Control+Alt+Z hotkey.
MouseGetPos, MouseX, MouseY
PixelGetColor, color, %MouseX%, %MouseY%
MsgBox The color at the current cursor position is %color%.
clipboard := color



;scan := new ShinsImageScanClass("OBS 27.2.4 (64-bit, windows) - Profile: Untitled - Scenes: Untitled") 
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


esc::exitapp

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

MouseGetPos(Options := 3) {
color := scan.GetPixel(mx,my) & 0xFFFFFF
MouseGetPos, X, Y, Win, Ctrl, % Options
MouseGetPos, MX, MY
PixelGetColor, color, %MX%, %MY%

Return {X: X, Y: Y, Win: Win, Ctrl: Ctrl, color : color }
	}
