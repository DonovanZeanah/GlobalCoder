#include ..\FindText.ahk
WinActivate("Examples.png")
WinWaitActive("Examples.png")

; first lets add images of letters "a" and "s" to the default image library
FindText().PicLib("|<a>**50$9.TXz0MzTzXkT7TtvU", 1)
FindText().PicLib("|<s>**50$8.DbzXs7kz0wDzTc", 1)

FindText(&X, &Y,,,,, 0.15, 0.15, FindText().PicN("sas"),,,1,5,3) ; FindText().PicN("sas") assembles Text for the word "sas" using our image library. Error margins were set to 15%, because all the "a" and "s" characters differ a little bit and with 15% all instances of them will be found. OffsetX=5 and OffsetY=3, because the default offset values are too large for this case.
FindText().MouseTip(X, Y)
FindText(&X, &Y,,,,, 0.15, 0.15, FindText().PicN("asa"),,,1,5,3) ; looks for the word "asa"
FindText().MouseTip(X, Y)