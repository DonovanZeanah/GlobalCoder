#include ..\FindText.ahk

Text := FindText().GetTextFromScreen(0, 0, 50, 30, "*100")
MsgBox("Text:`n" Text "`n`nASCII: `n" FindText().ASCII(Text))

FindText().Screenshot(100,100,500,500) ; Take a new screenshot between coordinates 100,100 and 500,500
FindText().ShowScreenShot(100, 100,500, 500, 0) ; Shows the taken screenshot on the screen. Since we specified 0 as the last argument, the function will use the screenshot taken previously by the Screenshot function.
Sleep(3000)

FindText().ShowScreenShot() ; Hide the screenshot after 3 seconds
FindText().SavePic(A_ScriptDir "\TestScreenShot.png", 100, 100, 400, 400, 0) ; Save a portion of the taken screenshot into a file in the script directory.