#include ..\FindText.ahk
WinActivate("Examples.png")
WinWaitActive("Examples.png") 
 
 ; first lets add images of letters "a" and "s" to the default image library
 FindText().PicLib("|<a>**50$9.TXz0MzTzXkT7TtvU", 1)
 FindText().PicLib("|<s>**50$8.DbzXs7kz0wDzTc", 1)
 ; find all "a" and "s" characters on the screen using our library
 ok:=FindText(&X, &Y,,,,, 0.15, 0.15, FindText().PicN("sa"))
 if (ocr := FindText().OCR(ok, 3, 3))
 MsgBox("Found " ocr.text) ; should return "aaa*sss*asa*sas